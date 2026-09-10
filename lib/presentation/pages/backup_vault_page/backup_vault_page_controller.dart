import 'dart:convert';
import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/services/vault/vault_service.dart';
import '../../../application/services/vaults_manager/vaults_manager_service.dart';
import 'backup_vault_page_state.dart';

class BackupFile {
  const BackupFile({required this.bytes, required this.fileName});

  final Uint8List bytes;
  final String fileName;
}

final backupVaultPageControllerProvider = StateNotifierProvider.autoDispose<
    BackupVaultPageController, BackupVaultPageState>(
  (ref) => BackupVaultPageController(ref),
);

class BackupVaultPageController extends StateNotifier<BackupVaultPageState> {
  BackupVaultPageController(this._ref) : super(const BackupVaultPageState());

  final Ref _ref;

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<BackupFile?> createBackup(String passphrase) async {
    state = state.copyWith(isProcessing: true, clearError: true);
    final passphraseBytes = Uint8List.fromList(utf8.encode(passphrase));

    try {
      final vaultState = _ref.read(vaultServiceProvider);
      final vaultId = vaultState.currentVaultId;
      if (vaultId == null) {
        state = state.copyWith(
          isProcessing: false,
          error: BackupVaultError.noOpenVault,
        );
        return null;
      }

      final entry =
          _ref.read(vaultsManagerServiceProvider).vaultRegistry[vaultId];
      final storedPassword = entry?.password;
      if (entry == null || storedPassword == null) {
        state = state.copyWith(
          isProcessing: false,
          error: BackupVaultError.detailsUnavailable,
        );
        return null;
      }
      if (passphrase != storedPassword) {
        state = state.copyWith(
          isProcessing: false,
          error: BackupVaultError.incorrectPassphrase,
        );
        return null;
      }

      final backupData = await _ref
          .read(vaultServiceProvider.notifier)
          .createBackup(passphrase: passphraseBytes);
      final rawJson = jsonDecode(
        utf8.decode(
          backupData.buffer.asUint8List(
            backupData.offsetInBytes,
            backupData.lengthInBytes,
          ),
        ),
      ) as Map<String, dynamic>;
      final fileContent = {
        ...rawJson,
        'vaultName': entry.vaultName,
      };
      final safeName = (entry.vaultName)
          .replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
      state = state.copyWith(isProcessing: false);
      return BackupFile(
        bytes: Uint8List.fromList(utf8.encode(jsonEncode(fileContent))),
        fileName:
            '$safeName-vault-backup-${DateTime.now().millisecondsSinceEpoch}.json',
      );
    } catch (_) {
      state = state.copyWith(
        isProcessing: false,
        error: BackupVaultError.failed,
      );
      return null;
    } finally {
      passphraseBytes.fillRange(0, passphraseBytes.length, 0);
    }
  }
}
