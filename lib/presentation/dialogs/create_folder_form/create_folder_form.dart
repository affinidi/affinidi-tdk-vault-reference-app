import 'package:flutter/material.dart';
import '../../../infrastructure/utils/constants.dart';
import '../../../l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../navigation/navigation_provider.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/bottom_sheet_dialog.dart';
import '../../widgets/loading_status/modal_async_loading_status.dart';
import 'create_folder_form_controller.dart';

class CreateFolderForm extends ConsumerWidget {
  const CreateFolderForm({
    required this.parentNodeId,
    required this.profileId,
    this.isSharedProfile = false,
    super.key,
  });

  final String? parentNodeId;
  final String profileId;
  final bool isSharedProfile;

  static void show({
    required BuildContext context,
    String? parentNodeId,
    required String profileId,
    bool isSharedProfile = false,
  }) =>
      showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => CreateFolderForm(
          parentNodeId: parentNodeId,
          profileId: profileId,
          isSharedProfile: isSharedProfile,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final provider = createFolderFormControllerProvider(parentNodeId: parentNodeId, profileId: profileId);
    final controller = ref.read(provider.notifier);
    final textController = controller.folderNameController;
    final navigation = ref.read(navigationServiceProvider);

    void onCancel() {
      if (!context.mounted) return;

      FocusScope.of(context).unfocus();
      navigation.pop();
    }

    void onCreateFolder() async {
      if (!context.mounted) return;

      await controller.create(
        isSharedProfile: isSharedProfile,
        onSuccess: () {
          if (!context.mounted) return;
          FocusScope.of(context).unfocus();
          navigation.pop();
        },
      );
    }

    return BottomSheetDialog(
      title: localizations.createFolderTitle,
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(localizations.cancelActionText),
        ),
        _CreateFolderButton(parentNodeId: parentNodeId, profileId: profileId, onCreateFolder: onCreateFolder),
      ],
      body: Column(
        children: [
          ModalAsyncLoadingStatus(
            loadingMessage: localizations.createFolderLoadingMessage,
            controller.loadingController,
          ),
          Column(
            spacing: AppSizing.paddingLarge,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                  constraints: BoxConstraints(minHeight: 72),
                  labelText: localizations.folderName,
                  hintText: localizations.folderName,
                  suffix: _ClearButton(parentNodeId: parentNodeId, profileId: profileId),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    onCreateFolder();
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
  const _ClearButton({this.parentNodeId, required this.profileId});

  final String? parentNodeId;
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = createFolderFormControllerProvider(parentNodeId: parentNodeId, profileId: profileId);
    final controller = ref.read(provider.notifier);
    final isCreateFolderButtonEnabled = ref.watch(provider.select((state) => state.isCreateFolderButtonEnabled));

    return isCreateFolderButtonEnabled
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

class _CreateFolderButton extends ConsumerWidget {
  const _CreateFolderButton({
    required this.onCreateFolder,
    this.parentNodeId,
    required this.profileId,
  });

  final void Function() onCreateFolder;
  final String? parentNodeId;
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final provider = createFolderFormControllerProvider(parentNodeId: parentNodeId, profileId: profileId);

    final isCreateFolderButtonEnabled = ref.watch(provider.select((state) => state.isCreateFolderButtonEnabled));

    return FilledButton(
      key: Key(KeyConstants.keyCreateFolderSubmitButton),
      onPressed: isCreateFolderButtonEnabled ? () => onCreateFolder() : null,
      child: Text(localizations.createFolderActionText),
    );
  }
}
