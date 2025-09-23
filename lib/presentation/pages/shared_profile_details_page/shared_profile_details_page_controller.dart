import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/storage/file_upload_service.dart';
import '../../../application/services/storage/storage_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../../navigation/navigation_provider.dart';
import '../../widgets/loading_status/async_loading_controller.dart';
import 'shared_profile_details_page_state.dart';

part 'shared_profile_details_page_controller.g.dart';

@riverpod
class SharedProfileDetailsPageController extends _$SharedProfileDetailsPageController {
  SharedProfileDetailsPageController() : super();

  final loadingController = AsyncLoadingController.provider('sharedProfileDetailsPageLoadingController');
  final fileUploadController = AsyncLoadingController.provider('sharedProfileDetailsPageFileUploadingController');

  @override
  SharedProfileDetailsPageState build({required String? parentNodeId, required String profileId}) {
    final provider = storageServiceProvider(parentNodeId: parentNodeId, profileId: profileId);
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

    return SharedProfileDetailsPageState(isLoading: true);
  }

  /// Lists all items in the current directory.
  ///
  /// Throws [AppException] if the storage repository cannot be accessed.
  Future<void> listItems() async {
    try {
      state = state.copyWith(isLoading: true);
      final sharedStorage = await ref.read(sharedStorageByIdProvider(profileId).future);
      final items = await sharedStorage.getFolder();
      state = state.copyWith(items: items.items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> uploadFiles() async {
    final localizations = AppLocalizations.of(navigatorKey.currentContext!);
    if (localizations == null) return;

    ref.read(fileUploadController.notifier).start(() async {
      final validFiles = await ref.read(fileUploadServiceProvider.notifier).pickAndValidateFiles(
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
          .read(storageServiceProvider(parentNodeId: parentNodeId, profileId: profileId).notifier)
          .getFileContent(fileId: item.id);
    });
  }

  void previewFile(Item node) {
    final navigation = ref.read(navigationServiceProvider);

    String path;
    if (parentNodeId != null) {
      path = '${ProfilesRoutePath.profileMyFiles(profileId)}/folder/$parentNodeId/preview/${node.id}';
    } else {
      path = ProfilesRoutePath.profileFilePreview(
        profileId,
        node.id,
      );
    }

    navigation.push(path);
  }
}
