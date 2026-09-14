import 'dart:typed_data';

enum RestoreVaultError {
  invalidFile,
  alreadyExists,
  failed,
}

class RestoreVaultPageState {
  const RestoreVaultPageState({
    this.backupBytes,
    this.pickedFileName,
    this.vaultName,
    this.restoredVaultId,
    this.isProcessing = false,
    this.error,
  });

  final Uint8List? backupBytes;
  final String? pickedFileName;
  final String? vaultName;
  final String? restoredVaultId;
  final bool isProcessing;
  final RestoreVaultError? error;

  RestoreVaultPageState copyWith({
    Uint8List? backupBytes,
    String? pickedFileName,
    String? vaultName,
    String? restoredVaultId,
    bool? isProcessing,
    RestoreVaultError? error,
    bool clearError = false,
  }) {
    return RestoreVaultPageState(
      backupBytes: backupBytes ?? this.backupBytes,
      pickedFileName: pickedFileName ?? this.pickedFileName,
      vaultName: vaultName ?? this.vaultName,
      restoredVaultId: restoredVaultId ?? this.restoredVaultId,
      isProcessing: isProcessing ?? this.isProcessing,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
