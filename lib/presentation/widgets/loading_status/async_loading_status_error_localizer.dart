import 'package:affinidi_tdk_claim_verifiable_credential/oid4vci_claim_verifiable_credential.dart';
import '../../../l10n/app_localizations.dart';

import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../infrastructure/exceptions/file_upload_exception.dart';
import '../../../infrastructure/loggers/error_logger/error_logging_handler.dart';

mixin AsyncLoadingStatusErrorLocalizer {
  String? makeLocalizedErrorMessage(
    Object exception,
    StackTrace stackTrace,
    String Function(Object exception) errorLocalizer,
  ) {
    if (!((exception is AppException && exception.type != AppExceptionType.other) ||
        (exception is TdkException && exception.code != 'other') ||
        (exception is FileUploadException))) {
      // If the exception is of an unexpected type log an error
      ErrorLoggingHandler.instance.logError(exception, stackTrace);
    }

    return errorLocalizer(exception);
  }

  String errorLocalizer(AppLocalizations localizations, Object exception) {
    if (exception is TdkException) {
      return localizations.errorMessage(exception.code);
    }

    if (exception is AppException) {
      return (exception.message.isNotEmpty) ? exception.message : localizations.errorMessage(exception.type.name);
    }

    if (exception is FileUploadException) {
      return localizations.fileUploadErrorMessage(
        exception.filesWithErrors.keys.join('\n'),
        exception.completed,
        exception.total,
      );
    }

    return localizations.errorMessage('other');
  }
}
