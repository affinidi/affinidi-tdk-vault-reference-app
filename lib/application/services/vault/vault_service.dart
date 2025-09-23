import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_data_manager/affinidi_tdk_vault_data_manager.dart';
import 'package:affinidi_tdk_vault_edge_provider/affinidi_tdk_vault_edge_provider.dart';
import 'package:affinidi_tdk_vault_edge_drift_provider/affinidi_tdk_vault_edge_drift_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter/foundation.dart';
import 'package:affinidi_tdk_vault_flutter_utils/vault_flutter_utils.dart';
import 'package:uuid/uuid.dart';

import '../../../infrastructure/exceptions/app_exception.dart';
import '../vaults_manager/vaults_manager_service.dart';
import 'open_vault_params.dart';
import 'vault_service_state.dart';

part 'vault_service.g.dart';

@Riverpod(keepAlive: true)
class VaultService extends _$VaultService {
  VaultService() : super();

  int _accountIndex = 0;

  @override
  VaultServiceState build() {
    return VaultServiceState();
  }

  /// Creates and opens a Vault instance.
  ///
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
    final Uint8List seed = existingSeed != null ? _deriveSeedFromString(existingSeed) : _generateRandomSeed();
    final base64Seed = base64Encode(seed);

    final isVaultAlreadyExisting = _doesVaultWithSeedExist(base64Seed: base64Seed);
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

    final vaultsManagerService = ref.read(vaultsManagerServiceProvider.notifier);
    await vaultsManagerService.loadVaultAvailability();

    final profiles = await vault.listProfiles();
    _accountIndex = _getNextAccountIndex(profiles);
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
      throw AppException(message: 'No vault entry found for the given vaultId', type: AppExceptionType.invalidVaultId);
    }

    if (vaultEntry.password != password) {
      throw AppException(message: 'Incorrect password for the selected vault', type: AppExceptionType.invalidPassword);
    }

    state = state.copyWith(
      currentVault: vault,
      currentVaultId: vaultEntry.vaultId,
    );

    final profiles = await state.currentVault!.listProfiles();
    _accountIndex = _getNextAccountIndex(profiles);
    log('Set account index to: $_accountIndex', name: 'VaultService');

    log('Current number of profiles: ${profiles.length}', name: 'VaultService');
    for (final profile in profiles) {
      log('Profile: ${profile.name} (${profile.did})', name: 'VaultService');
    }
  }

  /// Resets the current vault session in memory.
  ///
  /// Clears the `currentVault` and `currentVaultId` state.
  void resetCurrentVault() {
    log('Reseting current vault...', name: 'VaultService');

    state = state.copyWith(
      currentVault: null,
      currentVaultId: null,
    );
    log('Finished resetting current vault', name: 'VaultService');
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
    final profileRepositories = await _createProfileRepositories(vaultStorageKey, keyStore);

    // Set default to VFS
    final vfsRepositoryId = '${vaultStorageKey}_affinidi_cloud_repository';

    final vault = await Vault.fromVaultStore(
      keyStore,
      profileRepositories: profileRepositories,
      defaultProfileRepositoryId: vfsRepositoryId,
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

  /// Gets the next available account index by finding the highest used index
  int _getNextAccountIndex(List<Profile> profiles) {
    if (profiles.isEmpty) {
      return 0;
    }
    // Find the highest account index used
    final highestIndex = profiles.fold(0, (previousValue, element) => math.max(previousValue, element.accountIndex));
    // Return the next available index
    return highestIndex + 1;
  }

  /// Checks if a vault already exists for the given base64 seed.
  ///
  /// [base64Seed]: The encoded seed string to check against.
  ///
  /// Returns `true` if a vault exists, `false` otherwise.
  bool _doesVaultWithSeedExist({
    required String base64Seed,
  }) {
    final vaultRegistry = ref.read(vaultsManagerServiceProvider).vaultRegistry;
    return vaultRegistry.values.any((entry) => entry.base64Seed == base64Seed);
  }

  /// Creates a platform-specific database
  static Future<Database> _createPlatformDatabase(String repositoryId) async {
    final cleanRepositoryId = repositoryId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final databaseName = 'edge_profiles_$cleanRepositoryId.db';

    log('Database not found in cache, creating new one', name: 'VaultService');

    try {
      if (kIsWeb) {
        log('Creating web database', name: 'VaultService');
        return await DatabaseConfig.createDatabase(
          databaseName: databaseName,
        );
      } else {
        log('Creating native database', name: 'VaultService');
        final documentsDir = await getApplicationDocumentsDirectory();
        log('Documents directory: ${documentsDir.path}', name: 'VaultService');
        return await DatabaseConfig.createDatabase(
          databaseName: databaseName,
          directory: documentsDir.path,
        );
      }
    } catch (e, stackTrace) {
      log('Error creating database: $e', name: 'VaultService');
      log('Stack trace: $stackTrace', name: 'VaultService');
      rethrow;
    }
  }
}

/// Creates profile repositories for both VFS and Edge storage
/// Edge repositories are created with shared database for all Edge profiles
Future<Map<String, ProfileRepository>> _createProfileRepositories(
    String vaultId, FlutterSecureVaultStore keyStore) async {
  final profileRepositories = <String, ProfileRepository>{};

  try {
    // Always create VFS repository (cloud-based, no local storage)
    final vfsRepositoryId = '${vaultId}_affinidi_cloud_repository';
    log('Creating VFS repository with ID: $vfsRepositoryId', name: 'VaultService');
    profileRepositories[vfsRepositoryId] = VfsProfileRepository(vfsRepositoryId);
    log('VFS repository created', name: 'VaultService');

    // Create Edge repository with shared database for all Edge profiles
    final edgeRepositoryId = '${vaultId}_edge_repository';
    log('Creating Edge repository with ID: $edgeRepositoryId', name: 'VaultService');

    // Create database using platform-specific method
    final database = await VaultService._createPlatformDatabase(edgeRepositoryId);

    // Create encryption service
    final encryptionService = EdgeEncryptionService(vaultStore: keyStore);

    // Create repository factory
    final factory = EdgeDriftRepositoryFactory(database: database);

    // Create the edge profile repository
    final edgeRepository = EdgeProfileRepository(
      edgeRepositoryId,
      factory,
      encryptionService,
    );

    profileRepositories[edgeRepositoryId] = edgeRepository;
    log('Edge repository created', name: 'VaultService');

    log('Final repositories: ${profileRepositories.keys}', name: 'VaultService');
    return profileRepositories;
  } catch (e, stackTrace) {
    log('Error in _createProfileRepositories: $e', name: 'VaultService');
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
final _createVaultProvider = FutureProvider.family<Vault, OpenVaultParams>(
  (ref, param) async {
    try {
      // Get stored vault's seed from storage
      final vaultSeed = param.base64Seed;
      final vaultId = param.vaultId;

      final keyStore = FlutterSecureVaultStore(vaultId);
      await keyStore.setSeed(base64Decode(vaultSeed));

      // Content key will be created automatically by EdgeEncryptionService when needed
      final profileRepositories = await _createProfileRepositories(vaultId, keyStore);

      await ref.read(vaultsManagerServiceProvider.notifier).addVault(param);

      return Vault.fromVaultStore(
        keyStore,
        profileRepositories: profileRepositories,
        defaultProfileRepositoryId: '${vaultId}_affinidi_cloud_repository',
      );
    } catch (e, st) {
      log('Error creating vault [$param.vaultId]: $e', name: 'VaultService');
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
final _openVaultProvider = FutureProvider.family<Vault, String>(
  (ref, vaultId) async {
    try {
      final vaultRegistry = ref.read(vaultsManagerServiceProvider).vaultRegistry;

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

      final profileRepositories = await _createProfileRepositories(vaultId, keyStore);

      return Vault.fromVaultStore(
        keyStore,
        profileRepositories: profileRepositories,
        defaultProfileRepositoryId: '${vaultId}_affinidi_cloud_repository',
      );
    } catch (e, st) {
      log('Error opening vault for vaultId: $e', name: 'VaultService');
      log('Stack trace: $st', name: 'VaultService');
      rethrow;
    }
  },
  name: 'openVaultProvider',
);
