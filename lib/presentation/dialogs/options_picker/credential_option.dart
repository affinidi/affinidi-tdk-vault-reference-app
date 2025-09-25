enum CredentialOption {
  delete('assets/icons/icon-delete-outlined.svg'),
  share('assets/icons/icon-share.svg'),
  ;

  const CredentialOption(this.svgAssetName);

  final String svgAssetName;
}
