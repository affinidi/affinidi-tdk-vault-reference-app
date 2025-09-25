import 'package:go_router/go_router.dart';

extension InlinedPaths on GoRoute {
  List<String> inlinedPaths({String parentPath = ''}) {
    final root = [parentPath, path].join('/').replaceFirst('//', '/');
    List<String> allRoutes = [root];

    for (var subRoute in routes) {
      if (subRoute is GoRoute) {
        allRoutes.addAll(subRoute.inlinedPaths(parentPath: root));
      }
    }

    return allRoutes;
  }
}
