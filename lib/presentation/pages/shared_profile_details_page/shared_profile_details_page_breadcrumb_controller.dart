import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_profile_details_page_breadcrumb_controller.g.dart';

@riverpod
class SharedProfileDetailsPageBreadcrumbController extends _$SharedProfileDetailsPageBreadcrumbController {
  SharedProfileDetailsPageBreadcrumbController() : super();

  @override
  Map<String, String> build() {
    return {};
  }

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
