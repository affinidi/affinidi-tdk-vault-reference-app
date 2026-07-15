class KeyConstants {
  static final keyOptionButton = 'optionButton';
  static final keyRenameTextField = 'textFieldRename';
  static final keyButton = 'button';
  static final keyCreateFolderButton = 'createFolderButton';
  static final keyCreateFolderSubmitButton = 'createFolderSubmitButton';
  static final keyUploadFilesButton = 'uploadFilesButton';
  static final keyRadio = 'radio';

  static String keyClaimCredentialsButton = 'claimCredentialsButton';

  static String keyShareButton = 'shareButton';

  static String keyEnterDiDTextField = 'textFieldEnterDiD';
  static String keyCanWriteRadio = 'radioCanWrite';
  static String keyShareSubmitButton = 'ShareSubmitButton';

  static String keySettingsButton = 'settingsButton';

  static String keyDeleteProfiletButton = 'deleteProfileButton';
}

class AppConfig {
  // Application Configuration
  static const String appName = 'TDK Reference';

  // GitHub Configuration
  static const String githubUrl =
      'https://github.com/affinidi/affinidi-tdk/blob/main';
  static const String githubRawUrl =
      'https://raw.githubusercontent.com/affinidi/affinidi-tdk/refs/heads/main';

  // Affinidi API base URL. Override at build time with
  // --dart-define=AFFINIDI_API_BASE_URL=<url> to point at a different region
  // or environment.
  static const String affinidiApiBaseUrl = String.fromEnvironment(
    'AFFINIDI_API_BASE_URL',
    defaultValue: 'https://apse1.api.affinidi.io',
  );

  // Trusted OID4VP verifier hostnames (allowlist for VP submission).
  //
  // Defaults to the host of [affinidiApiBaseUrl] so the allowlist always tracks
  // the configured environment. Add extra hosts at build time with:
  //   --dart-define=TRUSTED_OID4VP_VERIFIERS=host1,host2
  static final List<String> trustedVerifiers = List.unmodifiable([
    _defaultVerifierHost,
    ...const String.fromEnvironment('TRUSTED_OID4VP_VERIFIERS')
        .split(',')
        .map((host) => host.trim())
        .where((host) => host.isNotEmpty),
  ]);

  static final String _defaultVerifierHost = () {
    final uri = Uri.tryParse(affinidiApiBaseUrl);
    return (uri != null && uri.host.isNotEmpty) ? uri.host : affinidiApiBaseUrl;
  }();
}
