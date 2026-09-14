import '../../../infrastructure/exceptions/app_exception.dart';

class DeleteProfileConfirmationState {
  final bool isLoading;
  final String? errorMessage;
  final AppExceptionType? errorType;
  final bool success;

  DeleteProfileConfirmationState({
    this.isLoading = false,
    this.errorMessage,
    this.errorType,
    this.success = false,
  });

  DeleteProfileConfirmationState copyWith({
    bool? isLoading,
    String? errorMessage,
    AppExceptionType? errorType,
    bool? success,
  }) {
    return DeleteProfileConfirmationState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      errorType: errorType,
      success: success ?? this.success,
    );
  }
}
