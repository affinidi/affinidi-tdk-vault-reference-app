import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/models/profile/profile_type.dart';

part 'create_profile_form_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class CreateProfileFormState with _$CreateProfileFormState {
  CreateProfileFormState._();

  factory CreateProfileFormState({
    @Default(false) bool hasName,
    @Default(false) bool hasDescription,
    @Default(ProfileType.affinidiCloud) ProfileType selectedProfileType,
  }) = _CreateProfileFormState;

  bool get isCreateProfileButtonEnabled => hasName;
}
