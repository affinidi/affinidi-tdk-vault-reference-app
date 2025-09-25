import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/storage/storage_service.dart';
import '../../widgets/loading_status/async_loading_controller.dart';
import 'rename_folder_form_state.dart';

part 'rename_folder_form_controller.g.dart';

@riverpod
class RenameFolderFormController extends _$RenameFolderFormController {
  RenameFolderFormController() : super();

  late TextEditingController folderNameController;
  final loadingController =
      AsyncLoadingController.provider('renameFolderFormLoadingController');

  @override
  RenameFolderFormState build({
    required Item item,
    required String? parentNodeId,
    required String profileId,
  }) {
    folderNameController = TextEditingController(text: item.name);

    void folderNameListener() {
      Future(() {
        state = state.copyWith(
            isRenameButtonEnabled: folderNameController.text.trim().isNotEmpty);
      });
    }

    folderNameController.addListener(folderNameListener);

    ref.onDispose(() {
      folderNameController.removeListener(folderNameListener);
      folderNameController.dispose();
    });

    return RenameFolderFormState(
        isRenameButtonEnabled: item.name.trim().isNotEmpty);
  }

  Future<void> rename({
    required void Function() onSuccess,
    bool isSharedProfile = false,
  }) async {
    await ref.read(loadingController.notifier).start(() async {
      await ref
          .read(storageServiceProvider(
                  parentNodeId: parentNodeId, profileId: profileId)
              .notifier)
          .renameFolder(
            folderId: item.id,
            newName: folderNameController.text,
            isSharedProfile: isSharedProfile,
          );
      onSuccess.call();
    });
  }

  void clearName() {
    folderNameController.clear();
  }
}
