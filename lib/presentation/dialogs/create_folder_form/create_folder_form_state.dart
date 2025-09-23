import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_folder_form_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class CreateFolderFormState with _$CreateFolderFormState {
  factory CreateFolderFormState({
    required bool isCreateFolderButtonEnabled,
  }) = _CreateFolderFormState;
}
