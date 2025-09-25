import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/storage/storage_service.dart';
import 'delete_folder_form_state.dart';

part 'delete_folder_form_controller.g.dart';

@riverpod
class DeleteFolderFormController extends _$DeleteFolderFormController {
  DeleteFolderFormController() : super();

  @override
  DeleteFolderFormState build({
    required Item folder,
    required String? parentNodeId,
    required String profileId,
  }) {
    return DeleteFolderFormState();
  }

  Future<void> delete({
    required Item folder,
    required String? parentNodeId,
    required String profileId,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null, success: false);
    try {
      await ref
          .read(storageServiceProvider(
                  parentNodeId: parentNodeId, profileId: profileId)
              .notifier)
          .deleteFolder(folderId: folder.id);
      state =
          state.copyWith(isLoading: false, errorMessage: null, success: true);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'Folder Not Deleted', success: false);
    }
  }
}
