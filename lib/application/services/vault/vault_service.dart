import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_data_manager/affinidi_tdk_vault_data_manager.dart';
import 'package:affinidi_tdk_vault_edge_provider/affinidi_tdk_vault_edge_provider.dart';
import 'package:affinidi_tdk_vault_edge_drift_provider/affinidi_tdk_vault_edge_drift_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter/foundation.dart';
import 'package:affinidi_tdk_vault_flutter_utils/affinidi_tdk_vault_flutter_utils.dart';
import 'package:uuid/uuid.dart';

import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../infrastructure/db/flutter_secure_consent_record_store.dart';
import '../vaults_manager/vaults_manager_service.dart';
import 'vault_backup_restore_service.dart';
import 'vault_service_constants.dart';
import 'open_vault_params.dart';
import 'vault_service_state.dart';

part 'vault_service.g.dart';

/// Logical, vaultId-independent profile repository identifiers.
///
/// Restoring a backup requires supplying repository registrations keyed by
/// the exact IDs baked into the encrypted backup, before it's decrypted. A
/// restoring device can't know the source vault's ID in advance, so these
/// IDs must not embed it — the local vaultId instead namespaces storage
/// directly (secure storage keys, database filenames).
///
/// Public so [ProfileService] can look up the right repository by
/// [ProfileType] without re-deriving these strings itself.
@Riverpod(keepAlive: true)
class VaultService extends _$VaultService implements VaultBackupRestoreHost {
  VaultService() : super();

  static final Map<String, Database> _edgeDatabases = {};

  @override
  VaultServiceState build() {
    return VaultServiceState();
  }

  /// Creates and opens a Vault instance.
  /// If [existingSeed] is provided, it will be used to initialize the vault's seed.
  /// Otherwise, a new random 32-byte seed will be generated.
  ///
  /// [vaultName]: The display name for the new vault.
  /// [password]: The passphrase used to secure the vault.
  /// [existingSeed] (optional): A string representation of the seed that will be converted to a Uint8List.
  Future<void> create({
    required String vaultName,
    required String password,
    String? existingSeed, // optional
  }) async {
    final uuid = Uuid();
    final vaultId = uuid.v4();

    // Use provided seed or generate a random one
    final Uint8List seed = existingSeed != null
        ? _deriveSeedFromString(existingSeed)
        : _generateRandomSeed();
    final base64Seed = base64Encode(seed);

    final isVaultAlreadyExisting =
        _doesVaultWithSeedExist(base64Seed: base64Seed);
    if (isVaultAlreadyExisting) {
      throw AppException(
        message: 'Vault already exists on this device.',
        type: AppExceptionType.vaultAlreadyExists,
      );
    }

    final vault = await ref.read(
      _createVaultProvider(
        OpenVaultParams(
          vaultName: vaultName,
          vaultId: vaultId,
          password: password,
          base64Seed: base64Seed,
        ),
      ).future,
    );

    await vault.ensureInitialized();

    state = state.copyWith(
      currentVault: vault,
      currentVaultId: vaultId,
    );

    final vaultsManagerService =
        ref.read(vaultsManagerServiceProvider.notifier);
    await vaultsManagerService.loadVaultAvailability();
  }

  /// Opens an existing Vault using [vaultId] and [password].
  ///
  /// Throws [AppException] if vault entry is missing or password is incorrect.
  ///
  /// [vaultId]: The unique ID of the vault.
  /// [password]: The passphrase used to unlock the vault.
  Future<void> open({required String vaultId, required String password}) async {
    log('Opening vault...', name: 'VaultService');
    final vaultsManagerServiceState = ref.read(vaultsManagerServiceProvider);
    final vaultRegistry = vaultsManagerServiceState.vaultRegistry;

    final vault = await ref.read(_openVaultProvider(
      vaultId,
    ).future);
    await vault.ensureInitialized();

    final vaultEntry = vaultRegistry[vaultId];
    if (vaultEntry == null) {
      throw AppException(
          message: 'No vault entry found for the given vaultId',
          type: AppExceptionType.invalidVaultId);
    }

    if (vaultEntry.password != password) {
      throw AppException(
          message: 'Incorrect password for the selected vault',
          type: AppExceptionType.invalidPassword);
    }

    state = state.copyWith(
      currentVault: vault,
      currentVaultId: vaultEntry.vaultId,
    );
  }

  /// Resets the current vault session in memory.
  ///
  /// Clears the `currentVault` and `currentVaultId` state.
  Future<void> resetCurrentVault() async {
    log('Reseting current vault...', name: 'VaultService');
    await _disposeCurrentVaultResources();
    state = state.copyWith(
      currentVault: null,
      currentVaultId: null,
    );
    log('Finished resetting current vault', name: 'VaultService');
  }

  Future<void> selectVault(
      {required String vaultId, required Vault vault}) async {
    await vault.ensureInitialized();
    state = state.copyWith(
      currentVault: vault,
      currentVaultId: vaultId,
    );
  }

  Future<ByteData> createBackup({required Uint8List passphrase}) async {
    return VaultBackupRestoreService(ref: ref, host: this).createBackup(
      passphrase: passphrase,
    );
  }

  Future<String> restoreFromBackupData({
    required ByteData backupData,
    required Uint8List passphrase,
    required String vaultName,
  }) async {
    return VaultBackupRestoreService(ref: ref, host: this)
        .restoreFromBackupData(
      backupData: backupData,
      passphrase: passphrase,
      vaultName: vaultName,
    );
  }

  /// Creates a Vault instance from a secure seed in storage.
  ///
  /// [vaultStorageKey]: Key used to retrieve secure seed from FlutterSecureStorage.
  /// [seed]: The seed used to initialize the vault instance.
  ///
  /// Returns a ready-to-use [Vault] instance
  Future<Vault> getVaultFromSecureStorage({
    required String vaultStorageKey,
    required Uint8List seed,
  }) async {
    final keyStore = FlutterSecureVaultStore(vaultStorageKey);
    await keyStore.setSeed(seed);

    // Create both VFS and Edge repositories
    final profileRepositories =
        await _createProfileRepositories(vaultStorageKey, keyStore);

    final vault = await Vault.fromVaultStore(
      keyStore,
      profileRepositories: profileRepositories,
      namedRestorables: _namedRestorables(vaultStorageKey),
      defaultProfileRepositoryId: cloudRepositoryId,
    );

    log('Vault [$vaultStorageKey] created successfully', name: 'VaultService');
    return vault;
  }

  /// Shares a profile from the current vault to another identity.
  ///
  /// [profileId]: The ID of the profile to be shared.
  /// [toDid]: The DID of the recipient.
  /// [permissions]: Access level for the recipient (default: all).
  ///
  /// Returns a [SharedProfileDto] object representing the shared profile.
  Future<SharedProfileDto?> shareProfile({
    required String profileId,
    required String toDid,
    Permissions permissions = Permissions.all,
    DateTime? expiresAt,
  }) async {
    if (state.currentVault == null) {
      throw AppException(
        message: 'Vault not initialized',
        type: AppExceptionType.vaultNotInitialized,
      );
    }
    return state.currentVault!.shareProfile(
      profileId: profileId,
      toDid: toDid,
      permissions: permissions,
      expiresAt: expiresAt,
    );
  }

  /// Adds a shared profile to the current vault without validation.
  ///
  /// [profileId]: The ID under which to store the shared profile.
  /// [sharedProfile]: The shared profile object to be added.
  Future<void> addSharedProfile({
    required String profileId,
    required SharedProfileDto sharedProfile,
  }) async {
    if (state.currentVault == null) {
      throw AppException(
        message: 'Vault not initialized',
        type: AppExceptionType.vaultNotInitialized,
      );
    }
    await state.currentVault!.addSharedProfile(
      profileId: profileId,
      sharedProfile: sharedProfile,
    );
  }

  /// Revokes access to a shared profile
  Future<void> revokeProfileAccess({
    required String profileId,
    required String granteeDid,
  }) async {
    if (state.currentVault == null) {
      throw AppException(
        message: 'Vault not initialized',
        type: AppExceptionType.vaultNotInitialized,
      );
    }
    await state.currentVault!.revokeProfileAccess(
      profileId: profileId,
      granteeDid: granteeDid,
    );
  }

  /// Shares an item (file/folder) with another user
  Future<void> shareItem({
    required String profileId,
    required String nodeId,
    required String toDid,
    required Permissions permissions,
    DateTime? expiresAt,
  }) async {
    if (state.currentVault == null) {
      throw AppException(
        message: 'Vault not initialized',
        type: AppExceptionType.vaultNotInitialized,
      );
    }
    final policy = await state.currentVault!.getItemPermissionsPolicy(
      profileId: profileId,
      granteeDid: toDid,
    );
    policy.addPermission([nodeId], [permissions], expiresAt: expiresAt);
    await state.currentVault!.setItemAccess(
      profileId: profileId,
      granteeDid: toDid,
      policy: policy,
    );
  }

  /// Revokes access to a shared item (file/folder)
  Future<void> revokeItemAccess({
    required String profileId,
    required String nodeId,
    required String granteeDid,
  }) async {
    if (state.currentVault == null) {
      throw AppException(
        message: 'Vault not initialized',
        type: AppExceptionType.vaultNotInitialized,
      );
    }
    try {
      final policy = await state.currentVault!.getItemPermissionsPolicy(
        profileId: profileId,
        granteeDid: granteeDid,
      );
      policy.removePermission([nodeId], []);
      await state.currentVault!.setItemAccess(
        profileId: profileId,
        granteeDid: granteeDid,
        policy: policy,
      );
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AppException(
        message: 'Failed to revoke item access: $e',
        type: AppExceptionType.vaultNotInitialized,
      );
    }
  }

  /// Gets access permissions for a specific item
  Future<List<ItemPermission>> getItemAccess({
    required String profileId,
    required String granteeDid,
  }) async {
    if (state.currentVault == null) {
      throw AppException(
        message: 'Vault not initialized',
        type: AppExceptionType.vaultNotInitialized,
      );
    }
    return await state.currentVault!.getItemAccess(
      profileId: profileId,
      granteeDid: granteeDid,
    );
  }

  /// Checks if a vault already exists for the given base64 seed.
  bool _doesVaultWithSeedExist({
    required String base64Seed,
  }) {
    final vaultRegistry = ref.read(vaultsManagerServiceProvider).vaultRegistry;
    return vaultRegistry.values.any((entry) => entry.base64Seed == base64Seed);
  }

  @override
  Vault? get currentVault => state.currentVault;

  @override
  Future<Database> createDatabase(String vaultId) =>
      _createPlatformDatabase(vaultId);

  @override
  Future<void> disposeDatabase(String vaultId) => disposeVaultDatabase(vaultId);

  @override
  Future<void> deleteDatabaseFile(String vaultId) async {
    await disposeVaultDatabase(vaultId);
    if (kIsWeb) return;
    final documentsDir = await getApplicationDocumentsDirectory();
    final databaseName = _databaseFileName(vaultId);
    for (final suffix in ['', '-wal', '-shm', '-journal']) {
      final file = io.File('${documentsDir.path}/$databaseName$suffix');
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  @override
  Future<Vault> openVault(String vaultId) async {
    ref.invalidate(_openVaultProvider(vaultId));
    final vault = await ref.read(_openVaultProvider(vaultId).future);
    await vault.ensureInitialized();
    return vault;
  }

  @override
  void setCurrentVault(String vaultId, Vault vault) {
    state = state.copyWith(
      currentVault: vault,
      currentVaultId: vaultId,
    );
  }

  /// Creates a platform-specific database, one per vault.
  static Future<Database> _createPlatformDatabase(String vaultId) async {
    final cached = _edgeDatabases[vaultId];
    if (cached != null) {
      return cached;
    }
    final databaseName = _databaseFileName(vaultId);

    try {
      if (kIsWeb) {
        log('Creating web database', name: 'VaultService');
        final database = await DatabaseConfig.createDatabase(
          databaseName: databaseName,
        );
        _edgeDatabases[vaultId] = database;
        return database;
      }
      log('Creating native database', name: 'VaultService');
      final documentsDir = await getApplicationDocumentsDirectory();
      log('Documents directory: ${documentsDir.path}', name: 'VaultService');
      final database = await DatabaseConfig.createDatabase(
        databaseName: databaseName,
        directory: documentsDir.path,
      );
      _edgeDatabases[vaultId] = database;
      return database;
    } catch (e, stackTrace) {
      log('Error creating database: ${e.runtimeType}', name: 'VaultService');
      log('Stack trace: $stackTrace', name: 'VaultService');
      rethrow;
    }
  }

  static String _databaseFileName(String vaultId) {
    final cleanVaultId = vaultId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    return 'edge_profiles_$cleanVaultId.db';
  }

  Future<void> _disposeCurrentVaultResources() async {
    // Intentionally does not close the edge database. Repositories and vault
    // objects may still hold a reference to it, and closing it would leave them
    // querying a closed connection. Each vault keeps one cached, open
    // connection to its own database file for the app's lifetime.
  }

  /// Closes and evicts the cached edge database for [vaultId].
  ///
  /// Releases the connection and file handle so the next access opens a fresh
  /// connection. Callers must ensure the vault's repositories are no longer in
  /// use (e.g. when the vault is removed, or right after a restore before the
  /// vault is reopened).
  Future<void> disposeVaultDatabase(String vaultId) async {
    final database = _edgeDatabases.remove(vaultId);
    await database?.close();
  }
}

/// The named restorables carried by every [Vault] this app builds.
///
/// Namespaced by [vaultId] so each vault's consent history backs up and
/// restores independently of every other vault's.
Map<String, Restorable> _namedRestorables(String vaultId) => {
      consentHistoryRestorableId: FlutterSecureConsentStorage(
        namespace: consentRecordNamespace(vaultId),
      ),
    };

/// Creates profile repositories for both VFS and Edge storage
/// Edge repositories are created with shared database for all Edge profiles
Future<Map<String, ProfileRepository>> _createProfileRepositories(
    String vaultId, FlutterSecureVaultStore keyStore) async {
  try {
    // Create database using platform-specific method. Always create VFS
    // repository (cloud-based, no local storage) and an Edge repository with
    // a shared database for all Edge profiles.
    final database = await VaultService._createPlatformDatabase(vaultId);
    final encryptionService = EdgeEncryptionService(vaultStore: keyStore);
    final edgeFactory = EdgeDriftRepositoryFactory(database: database);

    final profileRepositories = <String, ProfileRepository>{
      cloudRepositoryId: VfsProfileRepository(cloudRepositoryId),
      edgeRepositoryId: EdgeProfileRepository(
        edgeRepositoryId,
        edgeFactory,
        encryptionService,
      ),
    };

    log('Final repositories: ${profileRepositories.keys}',
        name: 'VaultService');
    return profileRepositories;
  } catch (e, stackTrace) {
    log('Error in _createProfileRepositories: ${e.runtimeType}',
        name: 'VaultService');
    log('Stack trace: $stackTrace', name: 'VaultService');
    rethrow;
  }
}

/// Generates a secure random 32-byte seed.
///
/// [length] (optional): Length of the seed, defaults to 32.
///
/// Returns a [Uint8List] containing the random seed bytes.
Uint8List _generateRandomSeed([int length = 32]) {
  final rng = math.Random.secure();
  return Uint8List.fromList(
    List<int>.generate(length, (_) => rng.nextInt(256)),
  );
}

/// Converts any input string into a 32-byte [Uint8List] seed using SHA-256.
///
/// [input]: The arbitrary input string to hash.
///
/// Returns a 32-byte seed derived from the input string.
Uint8List _deriveSeedFromString(String input) {
  final bytes = utf8.encode(input.trim());
  final hash = sha256.convert(bytes);
  return Uint8List.fromList(hash.bytes);
}

/// Creates a platform-specific database instance for Edge repository.
///
/// [repositoryId]: The unique ID of the repository.
///
/// Returns a [Database] instance, either for web or native platform.
final _createVaultProvider =
    AutoDisposeFutureProvider.family<Vault, OpenVaultParams>(
  (ref, param) async {
    try {
      // Get stored vault's seed from storage
      final vaultSeed = param.base64Seed;
      final vaultId = param.vaultId;

      final keyStore = FlutterSecureVaultStore(vaultId);
      await keyStore.setSeed(base64Decode(vaultSeed));

      // Content key will be created automatically by EdgeEncryptionService when needed
      final profileRepositories =
          await _createProfileRepositories(vaultId, keyStore);

      await ref.read(vaultsManagerServiceProvider.notifier).addVault(param);

      return Vault.fromVaultStore(
        keyStore,
        profileRepositories: profileRepositories,
        namedRestorables: _namedRestorables(vaultId),
        defaultProfileRepositoryId: cloudRepositoryId,
      );
    } catch (e, st) {
      log('Error creating vault [${param.vaultId}]: ${e.runtimeType}',
          name: 'VaultService');
      log('Stack trace: $st', name: 'VaultService');
      rethrow;
    }
  },
  name: '_createVaultProvider',
);

/// A [FutureProvider.family] that opens and returns a [Vault] instance for the given [vaultId].
///
/// This provider:
/// - Looks up the vault entry in the vault registry.
/// - Reads the seed from secure storage.
/// - Initializes profile repositories for the vault.
/// - Constructs the [Vault] using [Vault.fromVaultStore].
///
/// Throws an [Exception] if the vault entry or seed is not found.
final _openVaultProvider = AutoDisposeFutureProvider.family<Vault, String>(
  (ref, vaultId) async {
    try {
      final vaultRegistry =
          ref.read(vaultsManagerServiceProvider).vaultRegistry;

      final vaultEntry = vaultRegistry[vaultId];
      if (vaultEntry == null) {
        throw AppException(
          message: 'No vault entry found for given vaultId',
          type: AppExceptionType.invalidVaultId,
        );
      }

      final keyStore = FlutterSecureVaultStore(vaultId);

      final existingSeed = await keyStore.getSeed();

      if (existingSeed == null) {
        throw AppException(
          message: 'No seed found in secure storage for vault: $vaultId',
          type: AppExceptionType.seedNotFound,
        );
      }

      final profileRepositories =
          await _createProfileRepositories(vaultId, keyStore);

      return Vault.fromVaultStore(
        keyStore,
        profileRepositories: profileRepositories,
        namedRestorables: _namedRestorables(vaultId),
        defaultProfileRepositoryId: cloudRepositoryId,
      );
    } catch (e, st) {
      log('Error opening vault for vaultId: ${e.runtimeType}',
          name: 'VaultService');
      log('Stack trace: $st', name: 'VaultService');
      rethrow;
    }
  },
  name: 'openVaultProvider',
);
