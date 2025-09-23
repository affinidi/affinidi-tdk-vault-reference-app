import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../navigation/navigation_provider.dart';
import '../../widgets/bottom_sheet_dialog.dart';
import '../../widgets/loading_status/modal_async_loading_status.dart';
import 'delete_file_form_controller.dart';

class DeleteFileForm extends ConsumerWidget {
  const DeleteFileForm({
    required this.file,
    required this.parentNodeId,
    required this.profileId,
    super.key,
  });

  final Item file;
  final String? parentNodeId;
  final String profileId;

  static void show({
    required BuildContext context,
    required Item item,
    String? parentNodeId,
    required String profileId,
  }) =>
      showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => DeleteFileForm(file: item, parentNodeId: parentNodeId, profileId: profileId),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final provider = deleteFileFormControllerProvider(file: file, parentNodeId: parentNodeId, profileId: profileId);
    final controller = ref.read(provider.notifier);
    final navigation = ref.read(navigationServiceProvider);

    void cancel() {
      if (!context.mounted) return;

      navigation.pop();
    }

    void delete() async {
      if (!context.mounted) return;

      await controller.delete(
        onSuccess: () {
          if (!context.mounted) return;
          navigation.pop();
        },
      );
    }

    return BottomSheetDialog(
      title: localizations.deleteFileTitle,
      actions: [
        TextButton(
          onPressed: cancel,
          child: Text(localizations.cancelActionText),
        ),
        FilledButton(
          onPressed: () => delete(),
          child: Text(localizations.deleteFileActionText),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModalAsyncLoadingStatus(
            loadingMessage: localizations.deleteFileLoadingMessage,
            controller.loadingController,
          ),
          Text(localizations.deleteFileDescription),
        ],
      ),
      onCancel: () => cancel(),
    );
  }
}
