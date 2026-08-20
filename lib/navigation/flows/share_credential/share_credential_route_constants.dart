abstract class ShareCredentialRoutePath {
  static const base = '/share';
}

abstract class ShareCredentialRouteName {
  static const base = 'share';
}

abstract class ShareCredentialRouteParams {
  static const request = 'request';
  static const clientId = 'client_id';
  static const source = 'source';
}

/// Explicit entry point for the share-credential flow, passed via the route's
/// `source` query parameter so the controller can decide dispose-time cleanup
/// without inspecting the navigation stack.
abstract class ShareCredentialRouteSource {
  static const deeplink = 'deeplink';
  static const manual = 'manual';
}
