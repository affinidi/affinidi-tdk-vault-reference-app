import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/storage/file_upload_service.dart';
import '../../../application/services/storage/storage_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../../navigation/navigation_provider.dart';
import '../../widgets/loading_status/async_loading_controller.dart';
import 'my_files_page_state.dart';

part 'my_files_page_controller.g.dart';

@riverpod
class MyFilesPageController extends _$MyFilesPageController {
  MyFilesPageController() : super();

  final loadingController =
      AsyncLoadingController.provider('myFilesPageLoadingController');
  final fileUploadController =
      AsyncLoadingController.provider('myFilesPageFileUploadingController');
  final downloadingController =
      AsyncLoadingController.provider('myFilesPageDownloadingController');

  @override
  MyFilesPageState build(
      {required String? parentNodeId, required String profileId}) {
    final provider = storageServiceProvider(
        parentNodeId: parentNodeId, profileId: profileId);
    Future(() async {
      state = state.copyWith(isLoading: true);
      await ref.read(provider.notifier).listItems();
      state = state.copyWith(isLoading: false);
    });

    ref.listen(
      provider.select((state) => state.items),
      (previous, next) {
        Future(() {
          state = state.copyWith(items: next);
        });
      },
      fireImmediately: true,
    );

    return MyFilesPageState(isLoading: true);
  }

  Future<void> uploadFiles(AppLocalizations localizations) async {
    ref.read(fileUploadController.notifier).start(() async {
      final validFiles = await ref
          .read(fileUploadServiceProvider.notifier)
          .pickAndValidateFiles(
            parentNodeId: parentNodeId,
            profileId: profileId,
            localizations: localizations,
            isSharedProfile: false,
          );

      if (validFiles.isNotEmpty) {
        await ref.read(fileUploadServiceProvider.notifier).uploadFiles(
              files: validFiles,
              parentNodeId: parentNodeId,
              profileId: profileId,
              isSharedProfile: false,
            );
      }
    });
  }

  Future<void> downloadFile(Item item) async {
    ref.read(downloadingController.notifier).start(() async {
      await ref
          .read(storageServiceProvider(
                  parentNodeId: parentNodeId, profileId: profileId)
              .notifier)
          .getFileContent(
            fileId: item.id,
          );
    });
  }

  void previewFile(Item node) {
    final navigation = ref.read(navigationServiceProvider);

    String path;
    path = ProfilesRoutePath.profileFilePreview(
      profileId,
      node.id,
    );

    navigation.push(path);
  }
}
