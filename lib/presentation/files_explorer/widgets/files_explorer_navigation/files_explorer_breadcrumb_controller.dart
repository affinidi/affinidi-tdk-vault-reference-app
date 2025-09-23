import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'files_explorer_breadcrumb_controller.g.dart';

@riverpod
class FilesExplorerBreadcrumbController extends _$FilesExplorerBreadcrumbController {
  FilesExplorerBreadcrumbController() : super();

  @override
  Map<String, String> build(String screenKey) => {};

  void push({required String title, required String id}) {
    final folderMap = <String, String>{id: title};
    state.addAll(folderMap);
  }

  void pop({required String id}) {
    state.remove(id);
  }

  void clear() {
    state.clear();
  }

  void popUntil({required String id}) {
    final newStack = <String, String>{};

    for (final entry in state.entries) {
      newStack[entry.key] = entry.value;
      if (entry.key == id) break;
    }

    state
      ..clear()
      ..addAll(newStack);
  }
}
