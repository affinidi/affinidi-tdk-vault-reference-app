import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/material.dart';
import '../../../infrastructure/utils/constants.dart';
import '../../../l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../navigation/navigation_provider.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/bottom_sheet_dialog.dart';
import '../../widgets/loading_status/modal_async_loading_status.dart';
import 'rename_folder_form_controller.dart';

class RenameFolderForm extends ConsumerWidget {
  const RenameFolderForm({
    super.key,
    required this.folder,
    required this.parentNodeId,
    required this.profileId,
    this.isSharedProfile = false,
  });

  final Item folder;
  final String? parentNodeId;
  final String profileId;
  final bool isSharedProfile;

  static void show({
    required BuildContext context,
    required Item folder,
    String? parentNodeId,
    required String profileId,
    bool isSharedProfile = false,
  }) =>
      showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => RenameFolderForm(
          folder: folder,
          parentNodeId: parentNodeId,
          profileId: profileId,
          isSharedProfile: isSharedProfile,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final provider = renameFolderFormControllerProvider(item: folder, parentNodeId: parentNodeId, profileId: profileId);
    final controller = ref.read(provider.notifier);
    final textController = controller.folderNameController;
    final navigation = ref.read(navigationServiceProvider);

    void onCancel() {
      if (!context.mounted) return;

      FocusScope.of(context).unfocus();
      navigation.pop();
    }

    void onRenameFolder() async {
      if (!context.mounted) return;

      await controller.rename(
        isSharedProfile: isSharedProfile,
        onSuccess: () {
          if (!context.mounted) return;

          FocusScope.of(context).unfocus();
          navigation.pop();
        },
      );
    }

    return BottomSheetDialog(
      title: localizations.renameFolderTitle,
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(localizations.cancelActionText),
        ),
        _RenameButton(
          folder: folder,
          onRenameFolder: onRenameFolder,
          parentNodeId: parentNodeId,
          profileId: profileId,
        ),
      ],
      body: Column(
        children: [
          ModalAsyncLoadingStatus(
            loadingMessage: localizations.renameFolderLoadingMessage,
            controller.loadingController,
          ),
          Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localizations.renameFolderDescription),
              TextField(
                key: Key(KeyConstants.keyRenameTextField),
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                  constraints: BoxConstraints(minHeight: 72),
                  labelText: localizations.folderName,
                  hintText: localizations.folderName,
                  suffix: _ClearButton(folder: folder, parentNodeId: parentNodeId, profileId: profileId),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    onRenameFolder();
                  }
                },
              ),
            ],
          ),
        ],
      ),
      onCancel: () => onCancel(),
    );
  }
}

class _ClearButton extends ConsumerWidget {
  const _ClearButton({
    required this.folder,
    required this.parentNodeId,
    required this.profileId,
  });

  final Item folder;
  final String? parentNodeId;
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = renameFolderFormControllerProvider(item: folder, parentNodeId: parentNodeId, profileId: profileId);
    final controller = ref.read(provider.notifier);
    final isRenameButtonEnabled = ref.watch(provider.select((state) => state.isRenameButtonEnabled));

    return isRenameButtonEnabled
        ? GestureDetector(
            onTap: () => controller.clearName(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizing.paddingSmall),
              child: Icon(
                Icons.cancel_rounded,
                size: 16,
              ),
            ),
          )
        : SizedBox.shrink();
  }
}

class _RenameButton extends ConsumerWidget {
  const _RenameButton({
    required this.folder,
    required this.onRenameFolder,
    required this.parentNodeId,
    required this.profileId,
  });

  final Item folder;
  final String? parentNodeId;
  final String profileId;
  final void Function() onRenameFolder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final provider = renameFolderFormControllerProvider(item: folder, parentNodeId: parentNodeId, profileId: profileId);

    final isRenameButtonEnabled = ref.watch(provider.select((state) => state.isRenameButtonEnabled));

    return FilledButton(
      onPressed: isRenameButtonEnabled ? () => onRenameFolder() : null,
      child: Text(localizations.renameActionText),
    );
  }
}
