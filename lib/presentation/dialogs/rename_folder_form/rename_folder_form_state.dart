import 'package:freezed_annotation/freezed_annotation.dart';

part 'rename_folder_form_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class RenameFolderFormState with _$RenameFolderFormState {
  factory RenameFolderFormState({
    required bool isRenameButtonEnabled,
  }) = _RenameFolderFormState;
}
