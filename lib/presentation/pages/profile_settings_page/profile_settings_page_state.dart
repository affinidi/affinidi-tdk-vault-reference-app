import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_settings_page_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class ProfileSettingsPageState with _$ProfileSettingsPageState {
  const factory ProfileSettingsPageState({
    @Default(false) bool isSaving,
    Profile? profile,
    @Default({}) Set<int> revokingIds,
  }) = _ProfileSettingsPageState;
}
