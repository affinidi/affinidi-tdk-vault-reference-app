import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_sharing_page_state.freezed.dart';

@freezed
class ProfileSharingPageState with _$ProfileSharingPageState {
  const factory ProfileSharingPageState({
    @Default([]) List<Profile> profiles,
    String? selectedProfileId,
    @Default(false) bool isLoading,
  }) = _ProfileSharingPageState;
}
