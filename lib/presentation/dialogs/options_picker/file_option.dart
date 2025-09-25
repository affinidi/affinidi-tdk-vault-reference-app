enum FileOption {
  rename('assets/icons/icon-edit-outlined.svg'),
  delete('assets/icons/icon-delete-outlined.svg'),
  ;

  const FileOption(this.svgAssetName);

  final String svgAssetName;
}
