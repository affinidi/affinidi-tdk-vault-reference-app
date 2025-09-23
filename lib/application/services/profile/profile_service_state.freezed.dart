// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_service_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileServiceState {
  List<Profile>? get profiles => throw _privateConstructorUsedError;
  Map<String, bool> get profileEmptyStatus => throw _privateConstructorUsedError;

  /// Create a copy of ProfileServiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileServiceStateCopyWith<ProfileServiceState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileServiceStateCopyWith<$Res> {
  factory $ProfileServiceStateCopyWith(ProfileServiceState value, $Res Function(ProfileServiceState) then) =
      _$ProfileServiceStateCopyWithImpl<$Res, ProfileServiceState>;
  @useResult
  $Res call({List<Profile>? profiles, Map<String, bool> profileEmptyStatus});
}

/// @nodoc
class _$ProfileServiceStateCopyWithImpl<$Res, $Val extends ProfileServiceState>
    implements $ProfileServiceStateCopyWith<$Res> {
  _$ProfileServiceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileServiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profiles = freezed,
    Object? profileEmptyStatus = null,
  }) {
    return _then(_value.copyWith(
      profiles: freezed == profiles
          ? _value.profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>?,
      profileEmptyStatus: null == profileEmptyStatus
          ? _value.profileEmptyStatus
          : profileEmptyStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileServiceStateImplCopyWith<$Res> implements $ProfileServiceStateCopyWith<$Res> {
  factory _$$ProfileServiceStateImplCopyWith(
          _$ProfileServiceStateImpl value, $Res Function(_$ProfileServiceStateImpl) then) =
      __$$ProfileServiceStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Profile>? profiles, Map<String, bool> profileEmptyStatus});
}

/// @nodoc
class __$$ProfileServiceStateImplCopyWithImpl<$Res>
    extends _$ProfileServiceStateCopyWithImpl<$Res, _$ProfileServiceStateImpl>
    implements _$$ProfileServiceStateImplCopyWith<$Res> {
  __$$ProfileServiceStateImplCopyWithImpl(
      _$ProfileServiceStateImpl _value, $Res Function(_$ProfileServiceStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileServiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profiles = freezed,
    Object? profileEmptyStatus = null,
  }) {
    return _then(_$ProfileServiceStateImpl(
      profiles: freezed == profiles
          ? _value._profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>?,
      profileEmptyStatus: null == profileEmptyStatus
          ? _value._profileEmptyStatus
          : profileEmptyStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ));
  }
}

/// @nodoc

class _$ProfileServiceStateImpl implements _ProfileServiceState {
  _$ProfileServiceStateImpl({final List<Profile>? profiles, final Map<String, bool> profileEmptyStatus = const {}})
      : _profiles = profiles,
        _profileEmptyStatus = profileEmptyStatus;

  final List<Profile>? _profiles;
  @override
  List<Profile>? get profiles {
    final value = _profiles;
    if (value == null) return null;
    if (_profiles is EqualUnmodifiableListView) return _profiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, bool> _profileEmptyStatus;
  @override
  @JsonKey()
  Map<String, bool> get profileEmptyStatus {
    if (_profileEmptyStatus is EqualUnmodifiableMapView) return _profileEmptyStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_profileEmptyStatus);
  }

  @override
  String toString() {
    return 'ProfileServiceState(profiles: $profiles, profileEmptyStatus: $profileEmptyStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileServiceStateImpl &&
            const DeepCollectionEquality().equals(other._profiles, _profiles) &&
            const DeepCollectionEquality().equals(other._profileEmptyStatus, _profileEmptyStatus));
  }

  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(_profiles),
      const DeepCollectionEquality().hash(_profileEmptyStatus));

  /// Create a copy of ProfileServiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileServiceStateImplCopyWith<_$ProfileServiceStateImpl> get copyWith =>
      __$$ProfileServiceStateImplCopyWithImpl<_$ProfileServiceStateImpl>(this, _$identity);
}

abstract class _ProfileServiceState implements ProfileServiceState {
  factory _ProfileServiceState({final List<Profile>? profiles, final Map<String, bool> profileEmptyStatus}) =
      _$ProfileServiceStateImpl;

  @override
  List<Profile>? get profiles;
  @override
  Map<String, bool> get profileEmptyStatus;

  /// Create a copy of ProfileServiceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileServiceStateImplCopyWith<_$ProfileServiceStateImpl> get copyWith => throw _privateConstructorUsedError;
}
