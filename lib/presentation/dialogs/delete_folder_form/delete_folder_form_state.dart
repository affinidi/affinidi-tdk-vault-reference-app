class DeleteFolderFormState {
  final bool isLoading;
  final String? errorMessage;
  final bool success;

  DeleteFolderFormState({
    this.isLoading = false,
    this.errorMessage,
    this.success = false,
  });

  DeleteFolderFormState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? success,
  }) {
    return DeleteFolderFormState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      success: success ?? this.success,
    );
  }
}
