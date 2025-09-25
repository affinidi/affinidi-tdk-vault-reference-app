import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_page_state.freezed.dart';

@freezed
class SharedPageState with _$SharedPageState {
  const factory SharedPageState({
    @Default(false) bool isLoading,
    @Default([]) List<SharedStorage> sharedStorages,
    String? selectedProfileId,
    @Default({}) Map<String, List<dynamic>> sharedFiles,
  }) = _SharedPageState;
}
