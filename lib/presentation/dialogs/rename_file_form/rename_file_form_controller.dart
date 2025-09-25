import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/storage/storage_service.dart';
import '../../widgets/loading_status/async_loading_controller.dart';
import 'rename_file_form_state.dart';

part 'rename_file_form_controller.g.dart';

@riverpod
class RenameFileFormController extends _$RenameFileFormController {
  RenameFileFormController() : super();

  late TextEditingController fileNameController;
  final loadingController =
      AsyncLoadingController.provider('renameFileFormLoadingController');

  @override
  RenameFileFormState build({
    required Item item,
    required String? parentNodeId,
    required String profileId,
  }) {
    fileNameController = TextEditingController(text: item.name);

    void fileNameListener() {
      Future(() {
        state = state.copyWith(
            isRenameButtonEnabled: fileNameController.text.trim().isNotEmpty);
      });
    }

    fileNameController.addListener(fileNameListener);

    ref.onDispose(() {
      fileNameController.removeListener(fileNameListener);
      fileNameController.dispose();
    });

    return RenameFileFormState(
        isRenameButtonEnabled: item.name.trim().isNotEmpty);
  }

  Future<void> rename(
      {required void Function() onSuccess,
      bool isSharedProfile = false}) async {
    await ref.read(loadingController.notifier).start(() async {
      await ref
          .read(storageServiceProvider(
                  parentNodeId: parentNodeId, profileId: profileId)
              .notifier)
          .renameFile(
            itemId: item.id,
            newName: fileNameController.text,
            isSharedProfile: isSharedProfile,
          );
      onSuccess.call();
    });
  }

  void clearName() {
    fileNameController.clear();
  }
}
