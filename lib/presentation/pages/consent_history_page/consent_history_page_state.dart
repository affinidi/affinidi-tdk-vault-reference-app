import 'package:freezed_annotation/freezed_annotation.dart';

part 'consent_history_page_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class ConsentHistoryPageState with _$ConsentHistoryPageState {
  factory ConsentHistoryPageState() = _ConsentHistoryPageState;
}
