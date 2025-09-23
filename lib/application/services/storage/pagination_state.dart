import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_state.freezed.dart';
part 'pagination_state.g.dart';

@Freezed(fromJson: true, toJson: false)
class PaginationState with _$PaginationState {
  const factory PaginationState({
    @Default([]) List<String?> lastEvaluatedItemIdStack,
    @Default(0) int currentPageIndex,
  }) = _PaginationState;

  factory PaginationState.fromJson(Map<String, dynamic> json) => _$PaginationStateFromJson(json);
}
