import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_files_page_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class SharedFilesPageState with _$SharedFilesPageState {
  factory SharedFilesPageState({
    @Default(false) bool isLoading,
    List<Item>? items,
  }) = _SharedFilesPageState;
}
