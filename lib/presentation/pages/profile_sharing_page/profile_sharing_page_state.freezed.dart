// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_sharing_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileSharingPageState {
  List<Profile> get profiles => throw _privateConstructorUsedError;
  String? get selectedProfileId => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of ProfileSharingPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileSharingPageStateCopyWith<ProfileSharingPageState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileSharingPageStateCopyWith<$Res> {
  factory $ProfileSharingPageStateCopyWith(ProfileSharingPageState value, $Res Function(ProfileSharingPageState) then) =
      _$ProfileSharingPageStateCopyWithImpl<$Res, ProfileSharingPageState>;
  @useResult
  $Res call({List<Profile> profiles, String? selectedProfileId, bool isLoading});
}

/// @nodoc
class _$ProfileSharingPageStateCopyWithImpl<$Res, $Val extends ProfileSharingPageState>
    implements $ProfileSharingPageStateCopyWith<$Res> {
  _$ProfileSharingPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileSharingPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profiles = null,
    Object? selectedProfileId = freezed,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      profiles: null == profiles
          ? _value.profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>,
      selectedProfileId: freezed == selectedProfileId
          ? _value.selectedProfileId
          : selectedProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileSharingPageStateImplCopyWith<$Res> implements $ProfileSharingPageStateCopyWith<$Res> {
  factory _$$ProfileSharingPageStateImplCopyWith(
          _$ProfileSharingPageStateImpl value, $Res Function(_$ProfileSharingPageStateImpl) then) =
      __$$ProfileSharingPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Profile> profiles, String? selectedProfileId, bool isLoading});
}

/// @nodoc
class __$$ProfileSharingPageStateImplCopyWithImpl<$Res>
    extends _$ProfileSharingPageStateCopyWithImpl<$Res, _$ProfileSharingPageStateImpl>
    implements _$$ProfileSharingPageStateImplCopyWith<$Res> {
  __$$ProfileSharingPageStateImplCopyWithImpl(
      _$ProfileSharingPageStateImpl _value, $Res Function(_$ProfileSharingPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileSharingPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profiles = null,
    Object? selectedProfileId = freezed,
    Object? isLoading = null,
  }) {
    return _then(_$ProfileSharingPageStateImpl(
      profiles: null == profiles
          ? _value._profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>,
      selectedProfileId: freezed == selectedProfileId
          ? _value.selectedProfileId
          : selectedProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ProfileSharingPageStateImpl implements _ProfileSharingPageState {
  const _$ProfileSharingPageStateImpl(
      {final List<Profile> profiles = const [], this.selectedProfileId, this.isLoading = false})
      : _profiles = profiles;

  final List<Profile> _profiles;
  @override
  @JsonKey()
  List<Profile> get profiles {
    if (_profiles is EqualUnmodifiableListView) return _profiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_profiles);
  }

  @override
  final String? selectedProfileId;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'ProfileSharingPageState(profiles: $profiles, selectedProfileId: $selectedProfileId, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileSharingPageStateImpl &&
            const DeepCollectionEquality().equals(other._profiles, _profiles) &&
            (identical(other.selectedProfileId, selectedProfileId) || other.selectedProfileId == selectedProfileId) &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_profiles), selectedProfileId, isLoading);

  /// Create a copy of ProfileSharingPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileSharingPageStateImplCopyWith<_$ProfileSharingPageStateImpl> get copyWith =>
      __$$ProfileSharingPageStateImplCopyWithImpl<_$ProfileSharingPageStateImpl>(this, _$identity);
}

abstract class _ProfileSharingPageState implements ProfileSharingPageState {
  const factory _ProfileSharingPageState(
      {final List<Profile> profiles,
      final String? selectedProfileId,
      final bool isLoading}) = _$ProfileSharingPageStateImpl;

  @override
  List<Profile> get profiles;
  @override
  String? get selectedProfileId;
  @override
  bool get isLoading;

  /// Create a copy of ProfileSharingPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileSharingPageStateImplCopyWith<_$ProfileSharingPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
