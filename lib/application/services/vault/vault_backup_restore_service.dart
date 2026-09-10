import 'dart:convert';
import 'dart:typed_data';

import 'package:affinidi_tdk_cryptography/affinidi_tdk_cryptography.dart';
import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_data_manager/affinidi_tdk_vault_data_manager.dart';
import 'package:affinidi_tdk_vault_edge_drift_provider/affinidi_tdk_vault_edge_drift_provider.dart';
import 'package:affinidi_tdk_vault_edge_provider/affinidi_tdk_vault_edge_provider.dart';
import 'package:affinidi_tdk_vault_flutter_utils/affinidi_tdk_vault_flutter_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../infrastructure/db/flutter_secure_consent_record_store.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import '../vaults_manager/vaults_manager_service.dart';
import 'open_vault_params.dart';
import 'vault_service_constants.dart';

abstract interface class VaultBackupRestoreHost {
  Vault? get currentVault;

  Future<Database> createDatabase(String vaultId);

  Future<void> disposeDatabase(String vaultId);

  /// Closes and permanently deletes the per-vault database file for
  /// [vaultId], used to clean up after a failed restore.
  Future<void> deleteDatabaseFile(String vaultId);

  Future<Vault> openVault(String vaultId);

  void setCurrentVault(String vaultId, Vault vault);
}

class VaultBackupRestoreService {
  VaultBackupRestoreService(
      {required Ref ref, required VaultBackupRestoreHost host})
      : _ref = ref,
        _host = host;

  final Ref _ref;
  final VaultBackupRestoreHost _host;

  Future<ByteData> createBackup({required Uint8List passphrase}) async {
    final vault = _host.currentVault;
    if (vault == null) {
      throw AppException(
        message: 'Vault not initialized',
        type: AppExceptionType.vaultNotInitialized,
      );
    }

    final service = VaultBackupService(
      cryptographyService: CryptographyService(),
    );
    return service.createBackup(vault: vault, passphrase: passphrase);
  }

  Future<String> restoreFromBackupData({
    required ByteData backupData,
    required Uint8List passphrase,
    required String vaultName,
  }) async {
    final password = utf8.decode(passphrase);
    final vaultId = const Uuid().v4();
    final store = FlutterSecureVaultStore(vaultId);
    final database = await _host.createDatabase(vaultId);
    final edgeFactory = EdgeDriftRepositoryFactory(database: database);

    final service = VaultBackupService(
      cryptographyService: CryptographyService(),
    );

    Vault? restoredVault;
    try {
      restoredVault = await service.restoreBackup(
        backupData: backupData,
        passphrase: passphrase,
        vaultStoreFactory: () => store,
        repositoryFactories: {
          cloudRepositoryId: ProfileRepositoryRegistration.withoutBackupData(
            id: cloudRepositoryId,
            factory: (_) => VfsProfileRepository(cloudRepositoryId),
          ),
          edgeRepositoryId: ProfileRepositoryRegistration.withBackupData(
            id: edgeRepositoryId,
            factory: (vaultStore) => EdgeProfileRepository(
              edgeRepositoryId,
              edgeFactory,
              EdgeEncryptionService(vaultStore: vaultStore),
            ),
            asRestorable: restorableIdentity,
          ),
        },
        namedRestorableFactories: {
          consentHistoryRestorableId: () => FlutterSecureConsentStorage(
                namespace: consentRecordNamespace(vaultId),
              ),
        },
      );

      final seed = await store.getSeed();
      if (seed == null) {
        throw AppException(
          message: 'Seed not found after restoring backup.',
          type: AppExceptionType.seedNotFound,
        );
      }
      final base64Seed = base64Encode(seed);
      final registry = _ref.read(vaultsManagerServiceProvider).vaultRegistry;
      if (registry.values.any((entry) => entry.base64Seed == base64Seed)) {
        throw AppException(
          message: 'Vault already exists on this device.',
          type: AppExceptionType.vaultAlreadyExists,
        );
      }

      await _ref.read(vaultsManagerServiceProvider.notifier).addVault(
            OpenVaultParams(
              vaultId: vaultId,
              base64Seed: base64Seed,
              vaultName: vaultName,
              password: password,
            ),
          );
      await _ref
          .read(vaultsManagerServiceProvider.notifier)
          .loadVaultAvailability();

      await _host.disposeDatabase(vaultId);
      final openedVault = await _host.openVault(vaultId);
      _host.setCurrentVault(vaultId, openedVault);
      return vaultId;
    } catch (_) {
      // Any failure past this point leaves a fresh vaultId with a restored
      // (or partially restored) store and DB file; discard both so repeated
      // failed restores don't accumulate orphaned per-vault data.
      if (restoredVault != null) {
        try {
          await restoredVault.clearAllData();
        } catch (_) {
          // Best-effort; the original failure is what the caller needs to see.
        }
      }
      await _host.deleteDatabaseFile(vaultId);
      rethrow;
    }
  }
}
