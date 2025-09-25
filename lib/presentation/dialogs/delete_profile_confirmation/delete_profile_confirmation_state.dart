class DeleteProfileConfirmationState {
  final bool isLoading;
  final String? errorMessage;
  final bool success;

  DeleteProfileConfirmationState({
    this.isLoading = false,
    this.errorMessage,
    this.success = false,
  });

  DeleteProfileConfirmationState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? success,
  }) {
    return DeleteProfileConfirmationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      success: success ?? this.success,
    );
  }
}
