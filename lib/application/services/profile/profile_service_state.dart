import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_service_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class ProfileServiceState with _$ProfileServiceState {
  factory ProfileServiceState({
    List<Profile>? profiles,
    @Default({}) Map<String, bool> profileEmptyStatus,
  }) = _ProfileServiceState;
}
