import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/storage/storage_service.dart';
import '../../widgets/loading_status/async_loading_controller.dart';

part 'delete_file_form_controller.g.dart';

@riverpod
class DeleteFileFormController extends _$DeleteFileFormController {
  DeleteFileFormController() : super();

  final loadingController = AsyncLoadingController.provider('deleteFileFormLoadingController');

  @override
  void build({required Item file, String? parentNodeId, required String profileId}) {}

  Future<void> delete({required void Function() onSuccess}) async {
    await ref.read(loadingController.notifier).start(() async {
      await ref
          .read(storageServiceProvider(parentNodeId: parentNodeId, profileId: profileId).notifier)
          .deleteFile(itemId: file.id, fileId: file.id);

      onSuccess.call();
    });
  }
}
