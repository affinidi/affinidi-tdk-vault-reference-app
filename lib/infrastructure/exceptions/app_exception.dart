import 'package:dio/dio.dart';

import '../responses/error_response.dart';

enum AppExceptionType {
  missingClaimContext,
  missingVerifiableCredentials,
  folderNotEmpty,
  offline,
  nameAlreadyInUse,
  invalidPassword,
  invalidVaultId,
  invalidFiles,
  emptyPassword,
  missingProfileName,
  missingVaultId,
  missingProfile,
  missingSharedStorage,
  updateProfileFailure,
  missingRequiredData,
  vaultNotInitialized,
  databaseError,
  vaultAlreadyExists,
  seedNotFound,
  other,
  ;
}

class AppException implements Exception {
  AppException({
    required this.message,
    required this.type,
  });

  final String message;
  final AppExceptionType type;

  factory AppException.fromDioException(DioException exception) {
    final responseData = exception.response?.data;

    if (responseData == null) {
      return AppException(message: exception.toString(), type: AppExceptionType.other);
    }

    try {
      final errorResponse = ErrorResponse.fromJson(responseData);
      if (errorResponse.type == ErrorResponseType.operationNotAllowed &&
          errorResponse.details
              .any((details) => details.issue == 'Node with children cannot be operated for HARD_DELETE')) {
        return AppException(
            message: 'Folder is not empty and cannot be deleted', type: AppExceptionType.folderNotEmpty);
      }

      if (errorResponse.type == ErrorResponseType.nodeCreationError &&
          errorResponse.details.any((details) => details.issue == 'Folder name should be unique within the path')) {
        return AppException(
            message: 'Another folder with the same name already exists', type: AppExceptionType.nameAlreadyInUse);
      }

      if (errorResponse.type == ErrorResponseType.nodeUpdateError &&
          errorResponse.details.any((details) => details.issue == 'Node name should be unique within the path')) {
        return AppException(
            message: 'Another node with the same name already exists', type: AppExceptionType.nameAlreadyInUse);
      }

      return AppException(message: exception.toString(), type: AppExceptionType.other);
    } catch (error) {
      return AppException(message: exception.toString(), type: AppExceptionType.other);
    }
  }
}
