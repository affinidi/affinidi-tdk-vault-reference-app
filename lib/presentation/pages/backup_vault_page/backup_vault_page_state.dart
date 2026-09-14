enum BackupVaultError {
  noOpenVault,
  detailsUnavailable,
  incorrectPassphrase,
  failed,
}

class BackupVaultPageState {
  const BackupVaultPageState({
    this.isProcessing = false,
    this.error,
  });

  final bool isProcessing;
  final BackupVaultError? error;

  BackupVaultPageState copyWith({
    bool? isProcessing,
    BackupVaultError? error,
    bool clearError = false,
  }) {
    return BackupVaultPageState(
      isProcessing: isProcessing ?? this.isProcessing,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
