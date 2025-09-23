import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';
import 'delete_profile_confirmation_controller.dart';
import '../../widgets/code_snippet/code_snippet_widget.dart';
import '../../widgets/code_snippet/code_snippet_locations.dart';

class CustomErrorDialog extends ConsumerWidget {
  final String title;
  final String message;
  final String buttonText;

  const CustomErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final navigation = ref.read(navigationServiceProvider);

    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => navigation.pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }
}

class DeleteProfileConfirmation extends ConsumerStatefulWidget {
  const DeleteProfileConfirmation({
    super.key,
    required this.profileName,
    required this.profileId,
  });

  final String profileName;
  final String profileId;

  static Future<bool> show({
    required BuildContext context,
    required String profileName,
    required String profileId,
  }) {
    return showModalBottomSheet<bool>(
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      builder: (sheetContext) => DeleteProfileConfirmation(
        profileName: profileName,
        profileId: profileId,
      ),
    ).then((value) => value ?? false);
  }

  @override
  ConsumerState<DeleteProfileConfirmation> createState() =>
      _DeleteProfileConfirmationState();
}

class _DeleteProfileConfirmationState
    extends ConsumerState<DeleteProfileConfirmation> {
  void cancel() {
    if (!mounted) return;
    final navigation = ref.read(navigationServiceProvider);
    navigation.pop();
  }

  Future<void> delete() async {
    final controller =
        ref.read(deleteProfileConfirmationControllerProvider.notifier);
    controller.profileId = widget.profileId;
    await controller.delete();
    final state = ref.read(deleteProfileConfirmationControllerProvider);
    if (state.success && mounted) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final state = ref.watch(deleteProfileConfirmationControllerProvider);

    final isError = state.errorMessage != null;
    final isLoading = state.isLoading;

    return Container(
      decoration: const BoxDecoration(
        color: AppColorScheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizing.paddingMedium)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSizing.paddingMedium),
            child: Row(
              children: [
                Text(
                  isError
                      ? localizations.profileNotDeletedTitle
                      : localizations.deleteProfileTitle,
                  style: AppTheme.headingMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close,
                      color: AppColorScheme.textPrimary),
                  onPressed: cancel,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          // Separator
          const Divider(height: 1, color: AppColorScheme.divider),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSizing.paddingMedium),
            child: Text(
              isError
                  ? localizations.profileNotDeletedMessage
                  : localizations
                      .deleteProfileConfirmationMessage(widget.profileName),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          // Separator
          const Divider(height: 1, color: AppColorScheme.divider),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(AppSizing.paddingMedium),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: isLoading || isError ? null : cancel,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColorScheme.textPrimary,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSizing.paddingRegular),
                    ),
                    child: Text(
                      isError ? '' : localizations.cancelActionText,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizing.paddingRegular),
                Expanded(
                  child: CodeSnippetWidget(
                    title: localizations.lblCSCreateProfile,
                    codeLocations:
                        CodeSnippetLocations.deleteProfileSnippets(context),
                  ),
                ),
                const SizedBox(width: AppSizing.paddingRegular),
                Expanded(
                  child: Container(
                    height: AppSizing.iconXLarge,
                    decoration: BoxDecoration(
                      color: AppColorScheme.error,
                      borderRadius:
                          BorderRadius.circular(AppSizing.paddingSmall),
                    ),
                    child: TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              isError ? cancel() : delete();
                            },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColorScheme.backgroundWhite,
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSizing.paddingRegular),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: AppSizing.iconXSmall,
                              height: AppSizing.iconXSmall,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColorScheme.backgroundWhite),
                              ),
                            )
                          : Text(
                              isError
                                  ? localizations.gotItActionText
                                  : localizations.deleteActionText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColorScheme.backgroundWhite),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
