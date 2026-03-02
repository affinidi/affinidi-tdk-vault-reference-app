enum FolderOption {
  delete('assets/icons/icon-delete-outlined.svg'),
  rename('assets/icons/icon-edit-outlined.svg'),
  share('assets/icons/icon-share.svg'),
  manageAccess('assets/icons/icon-settings-outlined.svg'),
  ;

  const FolderOption(this.svgAssetName);

  final String svgAssetName;
}
