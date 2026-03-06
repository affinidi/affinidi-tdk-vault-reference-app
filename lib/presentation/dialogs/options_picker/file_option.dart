enum FileOption {
  rename('assets/icons/icon-edit-outlined.svg'),
  delete('assets/icons/icon-delete-outlined.svg'),
  share('assets/icons/icon-share.svg'),
  manageAccess('assets/icons/icon-settings-outlined.svg');

  const FileOption(this.svgAssetName);

  final String svgAssetName;
}
