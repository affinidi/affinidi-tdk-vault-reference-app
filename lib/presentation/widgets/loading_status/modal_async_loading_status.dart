import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../themes/app_sizing.dart';
import 'async_loading_controller.dart';
import 'async_loading_status_error_localizer.dart';

/// Use this widget to observe asynchronous executions and display a loading message.
/// In case of exceptions, displays the exception message in a dialog while hiding the loading message.
///
/// Example:
/// ```dart
/// ModalAsyncLoadingStatus(buttonControllerProvider)
/// ```
///
/// See also:
///
/// * [AsyncLoadingController] which is used as a provider
class ModalAsyncLoadingStatus extends HookConsumerWidget with AsyncLoadingStatusErrorLocalizer {
  const ModalAsyncLoadingStatus(
    this.provider, {
    super.key,
    this.loadingMessage,
  });

  final ProviderListenable<AsyncValue<void>> provider;
  final String? loadingMessage;

  void _showProgressDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizing.paddingRegular),
                  child: Text(loadingMessage ?? localizations.loading),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, Object exception, StackTrace stackTrace) {
    final localizations = AppLocalizations.of(context)!;
    String? localizedErrorMessage =
        makeLocalizedErrorMessage(exception, stackTrace, (error) => errorLocalizer(localizations, error));
    if (localizedErrorMessage == null) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Text(localizedErrorMessage),
          actionsPadding: const EdgeInsets.only(right: AppSizing.paddingSmall, bottom: AppSizing.paddingSmall),
          contentPadding: const EdgeInsets.all(AppSizing.paddingLarge),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.okActionText),
              onPressed: () {
                if (!context.mounted) return;
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShowingProgressDialog = useRef(false);

    void showProgressDialogIfNeeded(BuildContext context) {
      if (isShowingProgressDialog.value) {
        return;
      }

      isShowingProgressDialog.value = true;
      _showProgressDialog(context);
    }

    void dismissProgressDialogIfNeeded() {
      if (!isShowingProgressDialog.value) {
        return;
      }

      isShowingProgressDialog.value = false;
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
    }

    ref.listen<AsyncValue<void>>(
      provider,
      (_, state) => state.whenOrNull(
        error: (error, stackTrace) async {
          dismissProgressDialogIfNeeded();
          _showErrorDialog(context, error, stackTrace);
        },
        loading: () {
          showProgressDialogIfNeeded(context);
        },
        data: (_) async {
          dismissProgressDialogIfNeeded();
        },
      ),
    );

    return const SizedBox();
  }
}
