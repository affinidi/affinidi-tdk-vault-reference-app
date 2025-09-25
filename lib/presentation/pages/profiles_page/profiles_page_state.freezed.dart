// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profiles_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfilesPageState {
  List<Profile>? get profiles => throw _privateConstructorUsedError;

  /// Create a copy of ProfilesPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfilesPageStateCopyWith<ProfilesPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfilesPageStateCopyWith<$Res> {
  factory $ProfilesPageStateCopyWith(
          ProfilesPageState value, $Res Function(ProfilesPageState) then) =
      _$ProfilesPageStateCopyWithImpl<$Res, ProfilesPageState>;
  @useResult
  $Res call({List<Profile>? profiles});
}

/// @nodoc
class _$ProfilesPageStateCopyWithImpl<$Res, $Val extends ProfilesPageState>
    implements $ProfilesPageStateCopyWith<$Res> {
  _$ProfilesPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfilesPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profiles = freezed,
  }) {
    return _then(_value.copyWith(
      profiles: freezed == profiles
          ? _value.profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfilesPageStateImplCopyWith<$Res>
    implements $ProfilesPageStateCopyWith<$Res> {
  factory _$$ProfilesPageStateImplCopyWith(_$ProfilesPageStateImpl value,
          $Res Function(_$ProfilesPageStateImpl) then) =
      __$$ProfilesPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Profile>? profiles});
}

/// @nodoc
class __$$ProfilesPageStateImplCopyWithImpl<$Res>
    extends _$ProfilesPageStateCopyWithImpl<$Res, _$ProfilesPageStateImpl>
    implements _$$ProfilesPageStateImplCopyWith<$Res> {
  __$$ProfilesPageStateImplCopyWithImpl(_$ProfilesPageStateImpl _value,
      $Res Function(_$ProfilesPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfilesPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profiles = freezed,
  }) {
    return _then(_$ProfilesPageStateImpl(
      profiles: freezed == profiles
          ? _value._profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>?,
    ));
  }
}

/// @nodoc

class _$ProfilesPageStateImpl implements _ProfilesPageState {
  _$ProfilesPageStateImpl({final List<Profile>? profiles})
      : _profiles = profiles;

  final List<Profile>? _profiles;
  @override
  List<Profile>? get profiles {
    final value = _profiles;
    if (value == null) return null;
    if (_profiles is EqualUnmodifiableListView) return _profiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ProfilesPageState(profiles: $profiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfilesPageStateImpl &&
            const DeepCollectionEquality().equals(other._profiles, _profiles));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_profiles));

  /// Create a copy of ProfilesPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfilesPageStateImplCopyWith<_$ProfilesPageStateImpl> get copyWith =>
      __$$ProfilesPageStateImplCopyWithImpl<_$ProfilesPageStateImpl>(
          this, _$identity);
}

abstract class _ProfilesPageState implements ProfilesPageState {
  factory _ProfilesPageState({final List<Profile>? profiles}) =
      _$ProfilesPageStateImpl;

  @override
  List<Profile>? get profiles;

  /// Create a copy of ProfilesPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfilesPageStateImplCopyWith<_$ProfilesPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
