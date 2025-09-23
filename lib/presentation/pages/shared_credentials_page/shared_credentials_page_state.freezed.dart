// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_credentials_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SharedCredentialsPageState {
  List<DigitalCredential>? get digitalCredentials => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of SharedCredentialsPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SharedCredentialsPageStateCopyWith<SharedCredentialsPageState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedCredentialsPageStateCopyWith<$Res> {
  factory $SharedCredentialsPageStateCopyWith(
          SharedCredentialsPageState value, $Res Function(SharedCredentialsPageState) then) =
      _$SharedCredentialsPageStateCopyWithImpl<$Res, SharedCredentialsPageState>;
  @useResult
  $Res call({List<DigitalCredential>? digitalCredentials, bool isLoading});
}

/// @nodoc
class _$SharedCredentialsPageStateCopyWithImpl<$Res, $Val extends SharedCredentialsPageState>
    implements $SharedCredentialsPageStateCopyWith<$Res> {
  _$SharedCredentialsPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SharedCredentialsPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? digitalCredentials = freezed,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      digitalCredentials: freezed == digitalCredentials
          ? _value.digitalCredentials
          : digitalCredentials // ignore: cast_nullable_to_non_nullable
              as List<DigitalCredential>?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharedCredentialsPageStateImplCopyWith<$Res> implements $SharedCredentialsPageStateCopyWith<$Res> {
  factory _$$SharedCredentialsPageStateImplCopyWith(
          _$SharedCredentialsPageStateImpl value, $Res Function(_$SharedCredentialsPageStateImpl) then) =
      __$$SharedCredentialsPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DigitalCredential>? digitalCredentials, bool isLoading});
}

/// @nodoc
class __$$SharedCredentialsPageStateImplCopyWithImpl<$Res>
    extends _$SharedCredentialsPageStateCopyWithImpl<$Res, _$SharedCredentialsPageStateImpl>
    implements _$$SharedCredentialsPageStateImplCopyWith<$Res> {
  __$$SharedCredentialsPageStateImplCopyWithImpl(
      _$SharedCredentialsPageStateImpl _value, $Res Function(_$SharedCredentialsPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SharedCredentialsPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? digitalCredentials = freezed,
    Object? isLoading = null,
  }) {
    return _then(_$SharedCredentialsPageStateImpl(
      digitalCredentials: freezed == digitalCredentials
          ? _value._digitalCredentials
          : digitalCredentials // ignore: cast_nullable_to_non_nullable
              as List<DigitalCredential>?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SharedCredentialsPageStateImpl implements _SharedCredentialsPageState {
  _$SharedCredentialsPageStateImpl({final List<DigitalCredential>? digitalCredentials, this.isLoading = false})
      : _digitalCredentials = digitalCredentials;

  final List<DigitalCredential>? _digitalCredentials;
  @override
  List<DigitalCredential>? get digitalCredentials {
    final value = _digitalCredentials;
    if (value == null) return null;
    if (_digitalCredentials is EqualUnmodifiableListView) return _digitalCredentials;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'SharedCredentialsPageState(digitalCredentials: $digitalCredentials, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedCredentialsPageStateImpl &&
            const DeepCollectionEquality().equals(other._digitalCredentials, _digitalCredentials) &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(_digitalCredentials), isLoading);

  /// Create a copy of SharedCredentialsPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedCredentialsPageStateImplCopyWith<_$SharedCredentialsPageStateImpl> get copyWith =>
      __$$SharedCredentialsPageStateImplCopyWithImpl<_$SharedCredentialsPageStateImpl>(this, _$identity);
}

abstract class _SharedCredentialsPageState implements SharedCredentialsPageState {
  factory _SharedCredentialsPageState({final List<DigitalCredential>? digitalCredentials, final bool isLoading}) =
      _$SharedCredentialsPageStateImpl;

  @override
  List<DigitalCredential>? get digitalCredentials;
  @override
  bool get isLoading;

  /// Create a copy of SharedCredentialsPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SharedCredentialsPageStateImplCopyWith<_$SharedCredentialsPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
