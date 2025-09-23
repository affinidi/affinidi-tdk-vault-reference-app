import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/material.dart';
import '../../../infrastructure/utils/constants.dart';
import '../../../l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../navigation/navigation_provider.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/bottom_sheet_dialog.dart';
import '../../widgets/loading_status/modal_async_loading_status.dart';
import 'rename_file_form_controller.dart';

class RenameFileForm extends ConsumerWidget {
  const RenameFileForm({
    super.key,
    required this.file,
    required this.parentNodeId,
    required this.profileId,
    this.isSharedProfile = false,
  });

  final Item file;
  final String? parentNodeId;
  final String profileId;
  final bool isSharedProfile;

  static void show({
    required BuildContext context,
    required Item item,
    String? parentNodeId,
    required String profileId,
    bool isSharedProfile = false,
  }) =>
      showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => RenameFileForm(
          file: item,
          parentNodeId: parentNodeId,
          profileId: profileId,
          isSharedProfile: isSharedProfile,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final provider = renameFileFormControllerProvider(
      item: file,
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
    final controller = ref.read(provider.notifier);
    final textController = controller.fileNameController;
    final navigation = ref.read(navigationServiceProvider);

    void onCancel() {
      if (!context.mounted) return;

      FocusScope.of(context).unfocus();
      navigation.pop();
    }

    void onRenameFile() async {
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
      title: localizations.renameFileTitle,
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(localizations.cancelActionText),
        ),
        _RenameButton(
          file: file,
          parentNodeId: parentNodeId,
          profileId: profileId,
          onRenameFile: onRenameFile,
        ),
      ],
      body: Column(
        children: [
          ModalAsyncLoadingStatus(
            loadingMessage: localizations.renameFileLoadingMessage,
            controller.loadingController,
          ),
          Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localizations.renameFileDescription),
              TextField(
                key: Key(KeyConstants.keyRenameTextField),
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                  constraints: BoxConstraints(minHeight: 72),
                  labelText: localizations.fileName,
                  hintText: localizations.fileName,
                  suffix: _ClearButton(file: file, parentNodeId: parentNodeId, profileId: profileId),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    onRenameFile();
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
    required this.file,
    required this.parentNodeId,
    required this.profileId,
  });

  final Item file;
  final String? parentNodeId;
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = renameFileFormControllerProvider(item: file, parentNodeId: parentNodeId, profileId: profileId);
    final controller = ref.read(provider.notifier);
    final isRenameButtonEnabled = ref.watch(provider.select((state) => state.isRenameButtonEnabled));

    return isRenameButtonEnabled
        ? GestureDetector(
            onTap: () => controller.clearName(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizing.paddingSmall),
              child: Icon(
                Icons.cancel_rounded,
                size: AppSizing.iconXSmall,
              ),
            ),
          )
        : SizedBox.shrink();
  }
}

class _RenameButton extends ConsumerWidget {
  const _RenameButton({
    required this.file,
    required this.onRenameFile,
    required this.parentNodeId,
    required this.profileId,
  });

  final Item file;
  final String? parentNodeId;
  final String profileId;
  final void Function() onRenameFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final provider = renameFileFormControllerProvider(item: file, parentNodeId: parentNodeId, profileId: profileId);

    final isRenameButtonEnabled = ref.watch(provider.select((state) => state.isRenameButtonEnabled));

    return FilledButton(
      onPressed: isRenameButtonEnabled ? () => onRenameFile() : null,
      child: Text(localizations.renameActionText),
    );
  }
}
