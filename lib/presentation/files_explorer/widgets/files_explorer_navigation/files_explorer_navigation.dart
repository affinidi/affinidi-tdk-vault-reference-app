import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../infrastructure/utils/constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../themes/app_sizing.dart';

import 'files_explorer_breadcrumb_controller.dart';

class FilesExplorerNavigation extends ConsumerWidget {
  const FilesExplorerNavigation({
    super.key,
    required this.onCreateFolderPressed,
    required this.onUploadFilePressed,
    required this.screenKey,
    required this.onSelected,
  });

  final void Function() onCreateFolderPressed;
  final void Function() onUploadFilePressed;
  final void Function(String folderId) onSelected;
  final String screenKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final filesExplorerBreadcrumbrovider =
        filesExplorerBreadcrumbControllerProvider(screenKey);
    final folderStack = ref.watch(
      filesExplorerBreadcrumbrovider,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: PopupMenuButton(
              padding:
                  EdgeInsets.symmetric(horizontal: AppSizing.paddingRegular),
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSizing.paddingSmall,
                      children: [
                        Flexible(
                          child: _SelectedFolder(
                            folderStack: folderStack,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          size: AppSizing.iconMedium,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              onSelected: onSelected,
              itemBuilder: (context) => [
                ...folderStack.keys
                    .toList()
                    .reversed
                    .map((key) => PopupMenuItem(
                        value: key,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: AppSizing.paddingSmall,
                          children: [
                            Expanded(
                                child: Text(folderStack[key] ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1)),
                            SvgPicture.asset('assets/icons/documents-2.svg',
                                width: AppSizing.iconMedium,
                                height: AppSizing.iconMedium),
                          ],
                        ))),
                PopupMenuItem(
                    value: '',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: AppSizing.paddingSmall,
                      children: [
                        Text(localizations.home),
                        SvgPicture.asset('assets/icons/documents-2.svg',
                            width: AppSizing.iconMedium,
                            height: AppSizing.iconMedium),
                      ],
                    )),
              ],
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              key: Key(KeyConstants.keyCreateFolderButton),
              icon: SvgPicture.asset(
                'assets/icons/icon-add-folder.svg',
              ),
              onPressed: () => onCreateFolderPressed(),
            ),
            IconButton(
              key: Key(KeyConstants.keyUploadFilesButton),
              icon: SvgPicture.asset(
                'assets/icons/add-doc.svg',
              ),
              onPressed: () => onUploadFilePressed(),
            )
          ],
        )
      ],
    );
  }
}

class _SelectedFolder extends ConsumerWidget {
  final Map<String, String> folderStack;

  const _SelectedFolder({required this.folderStack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Text(
      folderStack.values.lastOrNull ?? localizations.home,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      softWrap: false,
    );
  }
}
