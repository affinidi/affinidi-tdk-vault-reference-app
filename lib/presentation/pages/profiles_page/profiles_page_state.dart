import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profiles_page_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class ProfilesPageState with _$ProfilesPageState {
  factory ProfilesPageState({
    List<Profile>? profiles,
  }) = _ProfilesPageState;
}
