import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/storage/file_upload_service.dart';
import '../../../application/services/storage/storage_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../../navigation/navigation_provider.dart';
import '../../widgets/loading_status/async_loading_controller.dart';
import 'shared_files_page_state.dart';

part 'shared_files_page_controller.g.dart';

@riverpod
class SharedFilesPageController extends _$SharedFilesPageController {
  SharedFilesPageController() : super();

  final loadingController =
      AsyncLoadingController.provider('sharedFilesPageLoadingController');
  final fileUploadController =
      AsyncLoadingController.provider('sharedFilesPageFileUploadingController');

  @override
  SharedFilesPageState build(
      {required String? parentNodeId, required String profileId}) {
    final provider = storageServiceProvider(
        parentNodeId: parentNodeId, profileId: profileId);
    Future(() async {
      state = state.copyWith(isLoading: true);
      await ref.read(provider.notifier).listItems(isSharedProfile: true);
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

    return SharedFilesPageState(isLoading: true);
  }

  Future<void> uploadFiles() async {
    final localizations = AppLocalizations.of(navigatorKey.currentContext!);
    if (localizations == null) return;

    ref.read(fileUploadController.notifier).start(() async {
      final validFiles = await ref
          .read(fileUploadServiceProvider.notifier)
          .pickAndValidateFiles(
            parentNodeId: parentNodeId,
            profileId: profileId,
            localizations: localizations,
            isSharedProfile: true,
          );

      if (validFiles.isNotEmpty) {
        await ref.read(fileUploadServiceProvider.notifier).uploadFiles(
              files: validFiles,
              parentNodeId: parentNodeId,
              profileId: profileId,
              isSharedProfile: true,
            );
      }
    });
  }

  Future<void> downloadFile(Item item) async {
    ref.read(fileUploadController.notifier).start(() async {
      await ref
          .read(storageServiceProvider(
                  parentNodeId: parentNodeId, profileId: profileId)
              .notifier)
          .getFileContent(
            fileId: item.id,
            isSharedProfile: true,
          );
    });
  }

  void previewFile(Item node) {
    final navigation = ref.read(navigationServiceProvider);

    String path;
    path = ProfilesRoutePath.sharedProfileFilePreview(
      profileId,
      node.id,
    );

    navigation.push(path);
  }
}
