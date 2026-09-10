import 'dart:convert';
import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/services/vault/vault_service.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../infrastructure/providers/localizations_provider.dart';
import 'restore_vault_page_state.dart';

final restoreVaultPageControllerProvider = StateNotifierProvider.autoDispose<
    RestoreVaultPageController, RestoreVaultPageState>(
  (ref) => RestoreVaultPageController(ref),
);

class RestoreVaultPageController extends StateNotifier<RestoreVaultPageState> {
  RestoreVaultPageController(this._ref) : super(const RestoreVaultPageState());

  final Ref _ref;

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  String? selectBackup({
    required Uint8List bytes,
    required String fileName,
    required String defaultVaultName,
  }) {
    try {
      final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      if (json['encryptedBackup'] is! String || json['salt'] is! String) {
        throw const FormatException('Invalid backup envelope');
      }
      final vaultName = json['vaultName'];
      state = state.copyWith(
        backupBytes: bytes,
        pickedFileName: fileName,
        vaultName: vaultName is String && vaultName.isNotEmpty
            ? vaultName
            : defaultVaultName,
        clearError: true,
      );
      return state.vaultName;
    } catch (_) {
      state = state.copyWith(error: RestoreVaultError.invalidFile);
      return null;
    }
  }

  void updateVaultName(String value) {
    state = state.copyWith(vaultName: value, clearError: true);
  }

  Future<void> restore({required String passphrase}) async {
    final backupBytes = state.backupBytes;
    if (backupBytes == null) return;

    state = state.copyWith(isProcessing: true, clearError: true);
    final passphraseBytes = Uint8List.fromList(utf8.encode(passphrase));
    try {
      final vaultId =
          await _ref.read(vaultServiceProvider.notifier).restoreFromBackupData(
                backupData: ByteData.sublistView(backupBytes),
                passphrase: passphraseBytes,
                vaultName: state.vaultName ??
                    _ref.read(localizationsProvider).restoredVaultDefaultName,
              );
      state = state.copyWith(
        isProcessing: false,
        restoredVaultId: vaultId,
      );
    } catch (error) {
      state = state.copyWith(
        isProcessing: false,
        error: error is AppException &&
                error.type == AppExceptionType.vaultAlreadyExists
            ? RestoreVaultError.alreadyExists
            : RestoreVaultError.failed,
      );
    } finally {
      passphraseBytes.fillRange(0, passphraseBytes.length, 0);
    }
  }
}
