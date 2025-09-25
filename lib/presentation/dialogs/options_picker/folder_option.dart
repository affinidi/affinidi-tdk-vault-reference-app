enum FolderOption {
  delete('assets/icons/icon-delete-outlined.svg'),
  rename('assets/icons/icon-edit-outlined.svg'),
  ;

  const FolderOption(this.svgAssetName);

  final String svgAssetName;
}
