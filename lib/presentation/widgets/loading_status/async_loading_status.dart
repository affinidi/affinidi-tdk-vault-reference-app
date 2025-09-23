import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../infrastructure/exceptions/app_exception.dart';
import '../../themes/app_sizing.dart';
import 'async_loading_controller.dart';
import 'async_loading_status_error_localizer.dart';

/// Use this widget to observe asynchronous executions and display a [loadingWidget].
/// In case of exceptions, displays the a centered localized exception and hides the loading message.
///
/// Example:
/// ```dart
/// AsyncLoadingStatus(asyncLoadingController)
/// ```
///
/// See also:
///
/// * [AsyncLoadingController] which is used as a provider
class AsyncLoadingStatus extends HookConsumerWidget with AsyncLoadingStatusErrorLocalizer {
  const AsyncLoadingStatus(
    this.provider, {
    super.key,
    this.initialLoading = false,
    required this.child,
    this.offlineRetry,
    this.loadingDescription,
  });

  final ProviderListenable<AsyncValue<void>> provider;
  final bool initialLoading;
  final Widget child;
  final void Function()? offlineRetry;
  final String? loadingDescription;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShowingProgress = useState(initialLoading);
    final errorText = useState<String?>(null);
    final shouldShowRetryButton = useState<bool>(false);
    final localizations = AppLocalizations.of(context)!;

    void resetState() {
      errorText.value = null;
      shouldShowRetryButton.value = false;
    }

    void showProgressWidgetIfNeeded(BuildContext context) {
      if (isShowingProgress.value) {
        return;
      }

      isShowingProgress.value = true;
    }

    void dismissProgressWidgetIfNeeded() {
      if (!isShowingProgress.value) {
        return;
      }

      isShowingProgress.value = false;
    }

    void showErrorWidgetIfNeeded(Object exception, StackTrace stackTrace) {
      String? localizedErrorMessage =
          makeLocalizedErrorMessage(exception, stackTrace, (error) => errorLocalizer(localizations, error));
      if (localizedErrorMessage == null || errorText.value == localizedErrorMessage) {
        return;
      }

      shouldShowRetryButton.value =
          ((offlineRetry != null) && (exception is AppException) && exception.type == AppExceptionType.offline);
      errorText.value = localizedErrorMessage;
    }

    ref.listen<AsyncValue<void>>(
      provider,
      (_, state) => state.whenOrNull(
        error: (error, stackTrace) async {
          dismissProgressWidgetIfNeeded();
          showErrorWidgetIfNeeded(error, stackTrace);
        },
        loading: () {
          showProgressWidgetIfNeeded(context);
        },
        data: (_) async {
          resetState();
          dismissProgressWidgetIfNeeded();
        },
      ),
    );

    return isShowingProgress.value
        ? Center(
            child: Padding(
            padding: EdgeInsets.all(AppSizing.paddingMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                CircularProgressIndicator(),
                if (loadingDescription != null && loadingDescription!.isNotEmpty) Text(loadingDescription!),
              ],
            ),
          ))
        : errorText.value != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizing.paddingRegular),
                  child: Column(
                    spacing: 24,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorText.value ?? localizations.errorMessage('other'),
                        textAlign: TextAlign.center,
                      ),
                      if (shouldShowRetryButton.value)
                        _RetryButton(onPressed: offlineRetry!, text: localizations.retryActionText),
                    ],
                  ),
                ),
              )
            : child;
  }
}

class _RetryButton extends StatelessWidget {
  const _RetryButton({
    required this.onPressed,
    required this.text,
  });

  final void Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
