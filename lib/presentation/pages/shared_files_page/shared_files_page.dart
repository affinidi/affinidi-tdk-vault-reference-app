import 'package:flutter/material.dart';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/profiles/profiles_route_constants.dart';
import '../../../navigation/navigation_provider.dart';
import '../../dialogs/create_folder_form/create_folder_form.dart';
import '../../files_explorer/widgets/files_explorer.dart';
import '../../files_explorer/widgets/files_explorer_navigation/files_explorer_breadcrumb_controller.dart';
import '../../files_explorer/widgets/files_explorer_navigation/files_explorer_navigation.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/loading_status/async_loading_status.dart';
import '../../widgets/loading_status/modal_async_loading_status.dart';

import 'shared_files_page_controller.dart';

class SharedFilesPage extends HookConsumerWidget {
  final screenKey = 'SharedFilesPage';

  const SharedFilesPage({
    super.key,
    this.parentNodeId,
    required this.profileId,
  });

  final String? parentNodeId;
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final currentFolderId = useState<String?>(parentNodeId);

    final provider = sharedFilesPageControllerProvider(
      parentNodeId: currentFolderId.value ??
          (GoRouterState.of(context).uri.queryParameters['folder']),
      profileId: profileId,
    );
    final nodes = ref.watch(provider.select((state) => state.items));
    final isLoading = ref.watch(provider.select((state) => state.isLoading));

    final filesExplorerBreadcrumbProvider =
        filesExplorerBreadcrumbControllerProvider('SharedFilesPage');
    final breadcrumbController =
        ref.read(filesExplorerBreadcrumbProvider.notifier);

    useEffect(() {
      final stack = ref.read(filesExplorerBreadcrumbProvider);

      if (currentFolderId.value != null && stack.isEmpty) {
        final items = ref.read(sharedFilesPageControllerProvider(
          parentNodeId: null,
          profileId: profileId,
        ).select((state) => state.items));

        String? folderName;
        if (items != null) {
          Folder? folder;
          try {
            folder = items
                .whereType<Folder>()
                .firstWhere((f) => f.id == currentFolderId.value);
          } catch (_) {
            folder = null;
          }
          folderName = folder?.name;
        }

        folderName ??= 'Folder';

        breadcrumbController.push(
            title: folderName, id: currentFolderId.value!);
      }
      return null;
    }, [currentFolderId.value]);

    final controller = ref.read(
      sharedFilesPageControllerProvider(
        parentNodeId: currentFolderId.value,
        profileId: profileId,
      ).notifier,
    );

    void showCreateFolderDialog() {
      if (!context.mounted) return;

      CreateFolderForm.show(
        context: context,
        parentNodeId: currentFolderId.value,
        profileId: profileId,
        isSharedProfile: true,
      );
    }

    void showFilePicker() async {
      if (!context.mounted) return;

      controller.uploadFiles();
    }

    return SafeArea(
      child: ColoredBox(
        color: Theme.of(context).canvasColor,
        child: Column(
          children: [
            ModalAsyncLoadingStatus(
              controller.fileUploadController,
              loadingMessage: localizations.uploadingFileLoadingMessage,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizing.paddingSmall,
                  AppSizing.paddingMedium,
                  AppSizing.paddingSmall,
                  AppSizing.paddingSmall),
              child: FilesExplorerNavigation(
                onCreateFolderPressed: showCreateFolderDialog,
                onUploadFilePressed: showFilePicker,
                screenKey: screenKey,
                onSelected: (String folderId) {
                  final navigation = ref.read(navigationServiceProvider);
                  final rootProfileId =
                      GoRouterState.of(context).pathParameters['id'] ?? '';

                  if (folderId.isNotEmpty) {
                    breadcrumbController.popUntil(
                      id: folderId,
                    );

                    navigation.pushReplacement(
                      ProfilesRoutePath.profileSharedProfileDetailsFolderPath(
                        rootProfileId,
                        profileId,
                        folderId,
                      ),
                    );
                    // }
                  } else {
                    breadcrumbController.clear();
                    navigation.pushReplacement(
                        ProfilesRoutePath.profileSharedProfileDetailsFiles(
                      rootProfileId,
                      profileId,
                    ));
                  }
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppSizing.paddingRegular),
                child: AsyncLoadingStatus(
                  controller.loadingController,
                  child: FilesExplorer(
                    isSharedProfile: true,
                    parentNodeId: currentFolderId.value,
                    profileId: profileId,
                    onFolderTap: ({required folderName, required folderId}) {
                      breadcrumbController.push(
                          title: folderName, id: folderId);
                      currentFolderId.value = folderId;
                    },
                    onPreviewFile: ref.read(provider.notifier).previewFile,
                    nodes: nodes,
                    isLoading: isLoading,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
