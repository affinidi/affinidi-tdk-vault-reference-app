import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../infrastructure/utils/constants.dart';
import '../../../infrastructure/extensions/node_extensions.dart';
import '../../../l10n/app_localizations.dart';
import '../../dialogs/delete_file_form/delete_file_form.dart';
import '../../dialogs/delete_folder_form/delete_folder_form.dart';
import '../../dialogs/options_picker/file_option.dart';
import '../../dialogs/options_picker/folder_option.dart';
import '../../dialogs/options_picker/options_picker.dart';
import '../../dialogs/rename_file_form/rename_file_form.dart';
import '../../dialogs/rename_folder_form/rename_folder_form.dart';
import '../../themes/app_sizing.dart';

class FilesExplorer extends ConsumerWidget {
  const FilesExplorer({
    super.key,
    required this.parentNodeId,
    required this.profileId,
    required this.onFolderTap,
    required this.onPreviewFile,
    required this.nodes,
    this.isLoading = false,
    this.isSharedProfile = false,
  });

  final String? parentNodeId;
  final String profileId;
  final void Function({required String folderName, required String folderId})
      onFolderTap;
  final void Function(Item node) onPreviewFile;
  final List<Item>? nodes;
  final bool isLoading;
  final bool isSharedProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    void showRenameFileDialog(Item item) {
      if (!context.mounted) return;

      RenameFileForm.show(
        context: context,
        item: item,
        parentNodeId: parentNodeId,
        profileId: profileId,
        isSharedProfile: isSharedProfile,
      );
    }

    void showDeleteFileDialog(Item item) {
      if (!context.mounted) return;

      DeleteFileForm.show(
        context: context,
        item: item,
        parentNodeId: parentNodeId,
        profileId: profileId,
      );
    }

    void preview(Item node) {
      if (!context.mounted) return;
      onPreviewFile(node);
    }

    void showFileOptions(Item item) async {
      if (!context.mounted) return;

      final fileOptions = <FileOption>[
        FileOption.rename,
        if (!isSharedProfile) FileOption.delete,
      ];

      final selectedFileOption = await OptionsPicker.show(
        useRootNavigator: true,
        context: context,
        options: fileOptions,
        itemLeadingBuilder: (option) => SvgPicture.asset(
          option.svgAssetName,
          width: AppSizing.iconSmall,
          height: AppSizing.iconSmall,
        ),
        itemTitleBuilder: (option) => Text(
          localizations.option(option.name),
        ),
      );

      if (selectedFileOption == null) return;

      switch (selectedFileOption) {
        case FileOption.rename:
          showRenameFileDialog(item);
        case FileOption.delete:
          showDeleteFileDialog(item);
      }
    }

    void showDeleteFolderDialog(Item item) {
      if (!context.mounted) return;

      DeleteFolderForm.show(
        context: context,
        folder: item,
        parentNodeId: parentNodeId,
        profileId: profileId,
      );
    }

    void showRenameFolderDialog(Item item) {
      if (!context.mounted) return;

      RenameFolderForm.show(
        context: context,
        folder: item,
        parentNodeId: parentNodeId,
        profileId: profileId,
        isSharedProfile: isSharedProfile,
      );
    }

    void showFolderOptions(Item item) async {
      if (!context.mounted) return;

      final folderOptions = <FolderOption>[
        FolderOption.rename,
        if (!isSharedProfile) FolderOption.delete,
      ];

      final selectedFolderOption = await OptionsPicker.show(
        useRootNavigator: true,
        context: context,
        options: folderOptions,
        itemLeadingBuilder: (option) => SvgPicture.asset(
          option.svgAssetName,
          width: AppSizing.iconSmall,
          height: AppSizing.iconSmall,
        ),
        itemTitleBuilder: (option) => Text(
          localizations.option(option.name),
        ),
      );

      log('selected: ${selectedFolderOption?.name}', name: 'FolderOptions');

      if (selectedFolderOption == null) return;

      switch (selectedFolderOption) {
        case FolderOption.delete:
          showDeleteFolderDialog(item);
        case FolderOption.rename:
          showRenameFolderDialog(item);
      }
    }

    if (nodes == null) {
      return SizedBox.shrink();
    }

    if (nodes!.isEmpty && !isLoading) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 42.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/illustration-no-files.svg',
                  width: 156, height: 82),
              const SizedBox(height: AppSizing.paddingLarge),
              Center(
                child: Text(
                  localizations.filesEmptyStateDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ));
    }

    return Column(
      children: [
        _Divider(),
        Expanded(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  itemCount: nodes!.length,
                  itemBuilder: (context, index) {
                    final item = nodes![index];
                    if (item is File) {
                      return _ListFileTile(
                        item: item,
                        onTap: () => preview(item),
                        onTapOptions: () => {showFileOptions(item)},
                      );
                    } else if (item is Folder) {
                      return _ListFolderTile(
                        item: item,
                        profileId: profileId,
                        parentNodeId: parentNodeId,
                        onTapOptions: () => showFolderOptions(item),
                        onFolderTap: onFolderTap,
                      );
                    }
                    return SizedBox.shrink();
                  },
                  separatorBuilder: (context, index) => _Divider(),
                ),
        ),
      ],
    );
  }
}

class _ListFolderTile extends ConsumerWidget {
  const _ListFolderTile({
    required this.item,
    required this.onTapOptions,
    required this.profileId,
    this.parentNodeId,
    required this.onFolderTap,
  });

  final Item item;
  final void Function() onTapOptions;
  final String profileId;
  final String? parentNodeId;
  final void Function({
    required String folderName,
    required String folderId,
  }) onFolderTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final localeName = localizations.localeName;

    return ListTile(
      onTap: () {
        onFolderTap(folderName: item.name, folderId: item.id);
      },
      contentPadding: EdgeInsets.only(left: AppSizing.paddingRegular),
      leading: SvgPicture.asset('assets/icons/documents-2.svg'),
      title: Text(item.name),
      subtitle: Text(item.formattedCreateDate(
        localeName,
      )),
      trailing: IconButton(
        key: Key('${KeyConstants.keyOptionButton}_${item.name}'),
        onPressed: onTapOptions,
        icon: Icon(CupertinoIcons.ellipsis),
      ),
    );
  }
}

class _ListFileTile extends ConsumerWidget {
  const _ListFileTile({
    required this.item,
    required this.onTapOptions,
    required this.onTap,
  });

  final Item item;
  final void Function()? onTap;
  final void Function() onTapOptions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final localeName = localizations.localeName;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.only(left: AppSizing.paddingRegular),
      leading: Hero(
          tag: item.id,
          child: SvgPicture.asset('assets/icons/documents-3.svg')),
      title: Text(item.name),
      subtitle: Text(item.formattedCreateDate(localeName)),
      trailing: IconButton(
        key: Key('${KeyConstants.keyOptionButton}_${item.name}'),
        onPressed: onTapOptions,
        icon: Icon(CupertinoIcons.ellipsis),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizing.paddingMedium,
      ),
      child: Divider(height: 1),
    );
  }
}
