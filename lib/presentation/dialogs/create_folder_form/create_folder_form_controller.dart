import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/storage/storage_service.dart';
import '../../widgets/loading_status/async_loading_controller.dart';
import 'create_folder_form_state.dart';

part 'create_folder_form_controller.g.dart';

@riverpod
class CreateFolderFormController extends _$CreateFolderFormController {
  CreateFolderFormController() : super();

  final folderNameController = TextEditingController();
  final loadingController = AsyncLoadingController.provider('createFolderFormLoadingController');

  @override
  CreateFolderFormState build({String? parentNodeId, required String profileId}) {
    void fileNameListener() {
      Future(() {
        state = state.copyWith(isCreateFolderButtonEnabled: folderNameController.text.trim().isNotEmpty);
      });
    }

    folderNameController.addListener(fileNameListener);

    ref.onDispose(() {
      folderNameController.removeListener(fileNameListener);
      folderNameController.dispose();
    });

    return CreateFolderFormState(isCreateFolderButtonEnabled: false);
  }

  Future<void> create({
    required void Function() onSuccess,
    bool isSharedProfile = false,
  }) async {
    await ref.read(loadingController.notifier).start(() async {
      await ref
          .read(storageServiceProvider(
            parentNodeId: parentNodeId,
            profileId: profileId,
          ).notifier)
          .createFolder(
            folderName: folderNameController.text,
            isSharedProfile: isSharedProfile,
          );
      onSuccess.call();
    });
  }

  void clearName() {
    folderNameController.clear();
  }
}
