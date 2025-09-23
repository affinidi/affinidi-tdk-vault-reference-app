import 'package:go_router/go_router.dart';

extension Paths on GoRouterState {
  String prependPath(String path) {
    final queryParameters = uri.queryParameters;
    final newPath = [path, matchedLocation].join('');
    return Uri(path: newPath, queryParameters: queryParameters).toString();
  }
}
