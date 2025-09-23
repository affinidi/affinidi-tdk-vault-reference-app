import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';
import 'delete_folder_form_controller.dart';

class DeleteFolderForm extends ConsumerWidget {
  const DeleteFolderForm({
    required this.folder,
    required this.parentNodeId,
    required this.profileId,
    super.key,
  });

  final Item folder;
  final String? parentNodeId;
  final String profileId;

  static void show({
    required BuildContext context,
    required Item folder,
    String? parentNodeId,
    required String profileId,
  }) =>
      showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => DeleteFolderForm(
            folder: folder, parentNodeId: parentNodeId, profileId: profileId),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final provider = deleteFolderFormControllerProvider(
        folder: folder, parentNodeId: parentNodeId, profileId: profileId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);
    final navigation = ref.read(navigationServiceProvider);

    ref.listen(provider, (previous, next) {
      if (next.success && context.mounted) {
        navigation.pop();
      }
    });

    void cancel() {
      if (!context.mounted) return;
      navigation.pop();
    }

    Future<void> delete() async {
      await controller.delete(
          folder: folder, parentNodeId: parentNodeId, profileId: profileId);
    }

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
                      ? localizations.folderNotDeletedTitle
                      : localizations.deleteFolderTitle,
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
                  ? localizations.folderNotDeletedMessage
                  : localizations.deleteFolderDescription,
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
                    onPressed: isLoading ? null : cancel,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColorScheme.textPrimary,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSizing.paddingRegular),
                    ),
                    child: Text(
                      localizations.cancelActionText,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
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
                              delete();
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
                                  : localizations.deleteFolderActionText,
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
