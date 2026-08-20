import 'dart:developer';
import 'package:go_router/go_router.dart';
import 'flows/app_routes.dart';

/// A wrapper around [GoRouter] that provides convenient and safe navigation methods
/// with built-in error handling and logging.
class NavigationService {
  final GoRouter _router;

  /// Creates a [NavigationService] that uses the provided [GoRouter] instance.
  NavigationService(this._router);

  /// Navigates to the given path and replaces the current route.
  ///
  /// [path]: The destination path (e.g. '/home').
  void go(String path) {
    try {
      _router.go(path);
    } catch (e, stackTrace) {
      _handleNavigationError('go', path, e, stackTrace);
    }
  }

  /// Pushes a new route onto the navigation stack.
  ///
  /// [path]: The destination path to push (e.g. '/details').
  void push(String path) {
    try {
      _router.push(path);
    } catch (e, stackTrace) {
      _handleNavigationError('push', path, e, stackTrace);
    }
  }

  /// Pushes a new route onto the navigation stack and removes the current one.
  ///
  /// [path]: The destination path to replace with (e.g. '/home').
  void pushReplacement(String path) {
    try {
      _router.pushReplacement(path);
    } catch (e, stackTrace) {
      _handleNavigationError('pushReplacement', path, e, stackTrace);
    }
  }

  /// Navigates to a named route and replaces the current route.
  ///
  /// [name]: The name of the route defined in GoRouter.
  /// [pathParameters]: (Optional) A map of path parameters (e.g. {'id': '123'}).
  /// [queryParameters]: (Optional) A map of query parameters (e.g. {'tab': 'info'}).
  void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
  }) {
    try {
      _router.goNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      );
    } catch (e, stackTrace) {
      _handleNavigationError('goNamed', name, e, stackTrace);
    }
  }

  /// Pops the current route off the navigation stack.
  ///
  /// [result]: (Optional) A result to return to the previous screen.
  void pop<T extends Object?>([T? result]) {
    try {
      _router.pop(result);
    } catch (e, stackTrace) {
      _handleNavigationError('pop', '<back>', e, stackTrace);
    }
  }

  /// Parses a raw OID4VP share URL, extracting the `request` JWT and optional `client_id`.
  ///
  /// Parameters:
  /// * [rawUrl] - The raw URL string entered by the user (e.g. a vault deep-link).
  ///
  /// Returns a record `(requestJwt, clientId)` on success, or `null` if [rawUrl]
  /// cannot be parsed or the `request` query parameter is absent or empty.
  ({String requestJwt, String? clientId})? parseShareUrl(String rawUrl) {
    final uri = Uri.tryParse(rawUrl.trim());
    final requestJwt = uri?.queryParameters[ShareCredentialRouteParams.request];
    if (requestJwt == null || requestJwt.isEmpty) return null;
    final clientId = uri?.queryParameters[ShareCredentialRouteParams.clientId];
    return (requestJwt: requestJwt, clientId: clientId);
  }

  /// Pushes the share credential page for the given [requestJwt].
  ///
  /// Parameters:
  /// * [requestJwt] - The JWT extracted from the OID4VP request URL.
  /// * [clientId] - Optional verifier client identifier.
  void pushShareCredential({required String requestJwt, String? clientId}) {
    final path = _buildShareCredentialPath(
      requestJwt: requestJwt,
      clientId: clientId,
    );
    push(path);
  }

  String _buildShareCredentialPath({
    required String requestJwt,
    String? clientId,
  }) {
    final path = Uri(
      path: ShareCredentialRoutePath.base,
      queryParameters: {
        ShareCredentialRouteParams.request: requestJwt,
        ShareCredentialRouteParams.source: ShareCredentialRouteSource.manual,
        if (clientId != null && clientId.isNotEmpty)
          ShareCredentialRouteParams.clientId: clientId,
      },
    ).toString();
    return path;
  }

  /// Pops the current route if possible; otherwise navigates to the vaults home screen.
  void popOrGoHome() {
    try {
      if (_router.canPop()) {
        _router.pop();
      } else {
        _router.go(VaultsRoutePath.base);
      }
    } catch (e, stackTrace) {
      _handleNavigationError(
          'popOrGoHome', VaultsRoutePath.base, e, stackTrace);
    }
  }

  /// Handles and logs navigation-related errors.
  ///
  /// [method]: The navigation method name (e.g. 'go', 'push').
  /// [path]: The target path or route name.
  /// [error]: The thrown error object.
  /// [stackTrace]: The stack trace associated with the error.
  void _handleNavigationError(
      String method, String path, Object error, StackTrace stackTrace) {
    log('[NavigationService] Error using $method to "$path": $error');
    log('$stackTrace');
  }
}
