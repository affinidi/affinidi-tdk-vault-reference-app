import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_files_page_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class MyFilesPageState with _$MyFilesPageState {
  factory MyFilesPageState({
    @Default(false) bool isLoading,
    List<Item>? items,
  }) = _MyFilesPageState;
}
