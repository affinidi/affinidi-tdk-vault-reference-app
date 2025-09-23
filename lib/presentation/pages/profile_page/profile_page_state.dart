import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_page_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class ProfilePageState with _$ProfilePageState {
  factory ProfilePageState({
    Profile? profile,
  }) = _ProfilePageState;
}
