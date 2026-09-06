import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/ports/external_redirect_launcher.dart';

/// Opens a verifier-supplied redirect URL in an external browser.
///
/// Wraps `url_launcher` so higher layers do not depend on it directly.
class ExternalRedirectService implements ExternalRedirectLauncher {
  const ExternalRedirectService();

  /// Launches [uri] externally, returning whether the launch succeeded.
  @override
  Future<bool> open(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);
}

final externalRedirectServiceProvider = Provider<ExternalRedirectService>(
  (ref) => const ExternalRedirectService(),
);
