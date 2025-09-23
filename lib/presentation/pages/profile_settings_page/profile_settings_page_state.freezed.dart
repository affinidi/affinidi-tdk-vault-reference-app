// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_settings_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileSettingsPageState {
  bool get isSaving => throw _privateConstructorUsedError;
  Profile? get profile => throw _privateConstructorUsedError;
  Set<int> get revokingIds => throw _privateConstructorUsedError;

  /// Create a copy of ProfileSettingsPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileSettingsPageStateCopyWith<ProfileSettingsPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileSettingsPageStateCopyWith<$Res> {
  factory $ProfileSettingsPageStateCopyWith(ProfileSettingsPageState value,
          $Res Function(ProfileSettingsPageState) then) =
      _$ProfileSettingsPageStateCopyWithImpl<$Res, ProfileSettingsPageState>;
  @useResult
  $Res call({bool isSaving, Profile? profile, Set<int> revokingIds});
}

/// @nodoc
class _$ProfileSettingsPageStateCopyWithImpl<$Res,
        $Val extends ProfileSettingsPageState>
    implements $ProfileSettingsPageStateCopyWith<$Res> {
  _$ProfileSettingsPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileSettingsPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSaving = null,
    Object? profile = freezed,
    Object? revokingIds = null,
  }) {
    return _then(_value.copyWith(
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      revokingIds: null == revokingIds
          ? _value.revokingIds
          : revokingIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileSettingsPageStateImplCopyWith<$Res>
    implements $ProfileSettingsPageStateCopyWith<$Res> {
  factory _$$ProfileSettingsPageStateImplCopyWith(
          _$ProfileSettingsPageStateImpl value,
          $Res Function(_$ProfileSettingsPageStateImpl) then) =
      __$$ProfileSettingsPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isSaving, Profile? profile, Set<int> revokingIds});
}

/// @nodoc
class __$$ProfileSettingsPageStateImplCopyWithImpl<$Res>
    extends _$ProfileSettingsPageStateCopyWithImpl<$Res,
        _$ProfileSettingsPageStateImpl>
    implements _$$ProfileSettingsPageStateImplCopyWith<$Res> {
  __$$ProfileSettingsPageStateImplCopyWithImpl(
      _$ProfileSettingsPageStateImpl _value,
      $Res Function(_$ProfileSettingsPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileSettingsPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSaving = null,
    Object? profile = freezed,
    Object? revokingIds = null,
  }) {
    return _then(_$ProfileSettingsPageStateImpl(
      isSaving: null == isSaving
          ? _value.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      revokingIds: null == revokingIds
          ? _value._revokingIds
          : revokingIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
    ));
  }
}

/// @nodoc

class _$ProfileSettingsPageStateImpl implements _ProfileSettingsPageState {
  const _$ProfileSettingsPageStateImpl(
      {this.isSaving = false,
      this.profile,
      final Set<int> revokingIds = const {}})
      : _revokingIds = revokingIds;

  @override
  @JsonKey()
  final bool isSaving;
  @override
  final Profile? profile;
  final Set<int> _revokingIds;
  @override
  @JsonKey()
  Set<int> get revokingIds {
    if (_revokingIds is EqualUnmodifiableSetView) return _revokingIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_revokingIds);
  }

  @override
  String toString() {
    return 'ProfileSettingsPageState(isSaving: $isSaving, profile: $profile, revokingIds: $revokingIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileSettingsPageStateImpl &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            const DeepCollectionEquality()
                .equals(other._revokingIds, _revokingIds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isSaving, profile,
      const DeepCollectionEquality().hash(_revokingIds));

  /// Create a copy of ProfileSettingsPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileSettingsPageStateImplCopyWith<_$ProfileSettingsPageStateImpl>
      get copyWith => __$$ProfileSettingsPageStateImplCopyWithImpl<
          _$ProfileSettingsPageStateImpl>(this, _$identity);
}

abstract class _ProfileSettingsPageState implements ProfileSettingsPageState {
  const factory _ProfileSettingsPageState(
      {final bool isSaving,
      final Profile? profile,
      final Set<int> revokingIds}) = _$ProfileSettingsPageStateImpl;

  @override
  bool get isSaving;
  @override
  Profile? get profile;
  @override
  Set<int> get revokingIds;

  /// Create a copy of ProfileSettingsPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileSettingsPageStateImplCopyWith<_$ProfileSettingsPageStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
