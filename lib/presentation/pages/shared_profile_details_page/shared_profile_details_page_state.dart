import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_profile_details_page_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class SharedProfileDetailsPageState with _$SharedProfileDetailsPageState {
  factory SharedProfileDetailsPageState({
    @Default(false) bool isLoading,
    List<Item>? items,
  }) = _SharedProfileDetailsPageState;
}
