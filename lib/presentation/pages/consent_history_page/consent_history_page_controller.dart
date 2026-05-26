import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'consent_history_page_state.dart';

part 'consent_history_page_controller.g.dart';

@riverpod
class ConsentHistoryPageController extends _$ConsentHistoryPageController {
  @override
  ConsentHistoryPageState build() {
    return ConsentHistoryPageState();
  }
}
