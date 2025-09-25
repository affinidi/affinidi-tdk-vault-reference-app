import 'package:freezed_annotation/freezed_annotation.dart';

part 'rename_file_form_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class RenameFileFormState with _$RenameFileFormState {
  factory RenameFileFormState({
    required bool isRenameButtonEnabled,
  }) = _RenameFileFormState;
}
