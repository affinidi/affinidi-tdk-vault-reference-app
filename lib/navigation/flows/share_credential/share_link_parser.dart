import 'share_credential_route_constants.dart';

/// Centralised validation rules for OID4VP share links.
///
/// Shared by the manual paste flow ([ShareLinkParser]) and the deep-link
/// redirect in `navigation_provider`, so both enforce identical constraints
/// instead of duplicating limits and formats.
abstract final class ShareRequestUrlRules {
  /// A compact OID4VP request JWT is well under 10 KB; larger or malformed
  /// input is rejected to avoid processing attacker-controlled junk.
  static const int maxJwtLength = 10000;

  /// Upper bound for the verifier `client_id`.
  static const int maxClientIdLength = 1000;

  /// A three-segment, base64url-ish JWT.
  static final RegExp jwtFormat =
      RegExp(r'^[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+$');

  /// Whether [jwt] is a plausible, in-bounds request JWT.
  static bool isValidJwt(String? jwt) =>
      jwt != null &&
      jwt.isNotEmpty &&
      jwt.length <= maxJwtLength &&
      jwtFormat.hasMatch(jwt);

  /// Whether [clientId] is a usable, in-bounds verifier client id.
  static bool isValidClientId(String? clientId) =>
      clientId != null &&
      clientId.isNotEmpty &&
      clientId.length <= maxClientIdLength;
}

/// Parameters extracted from an OID4VP share link.
typedef ShareLinkParams = ({String requestJwt, String? clientId});

/// Parses OID4VP share links and builds the in-app `/share` route.
///
/// Owned by the share-credential feature (not the generic navigation service)
/// so URL handling for this flow lives with the flow.
abstract final class ShareLinkParser {
  /// Extracts the `request` JWT and optional `client_id` from a raw share URL.
  ///
  /// Returns `null` when the URL cannot be parsed or the `request` parameter is
  /// absent or empty.
  static ShareLinkParams? parse(String rawUrl) {
    final uri = Uri.tryParse(rawUrl.trim());
    final requestJwt = uri?.queryParameters[ShareCredentialRouteParams.request];
    if (requestJwt == null || requestJwt.isEmpty) return null;
    final clientId = uri?.queryParameters[ShareCredentialRouteParams.clientId];
    return (requestJwt: requestJwt, clientId: clientId);
  }

  /// Builds the in-app share route, tagging how the flow was entered via
  /// [source] (defaults to [ShareCredentialRouteSource.manual]).
  static String buildPath({
    required String requestJwt,
    String? clientId,
    String source = ShareCredentialRouteSource.manual,
  }) =>
      Uri(
        path: ShareCredentialRoutePath.base,
        queryParameters: {
          ShareCredentialRouteParams.request: requestJwt,
          ShareCredentialRouteParams.source: source,
          if (clientId != null && clientId.isNotEmpty)
            ShareCredentialRouteParams.clientId: clientId,
        },
      ).toString();

  /// Resolves a deep-link [uri] to the in-app share route.
  ///
  /// Returns the share path when the link carries a valid request JWT, or
  /// `null` when it does not; the caller decides where to send invalid links.
  static String? resolveDeepLinkPath(Uri uri) {
    final jwt = uri.queryParameters[ShareCredentialRouteParams.request];
    if (!ShareRequestUrlRules.isValidJwt(jwt)) return null;
    final clientId = uri.queryParameters[ShareCredentialRouteParams.clientId];
    return buildPath(
      requestJwt: jwt!,
      clientId:
          ShareRequestUrlRules.isValidClientId(clientId) ? clientId : null,
      source: ShareCredentialRouteSource.deeplink,
    );
  }
}
