// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_credentials_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MyCredentialsPageState {
  List<DigitalCredential>? get digitalCredentials => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of MyCredentialsPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyCredentialsPageStateCopyWith<MyCredentialsPageState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyCredentialsPageStateCopyWith<$Res> {
  factory $MyCredentialsPageStateCopyWith(MyCredentialsPageState value, $Res Function(MyCredentialsPageState) then) =
      _$MyCredentialsPageStateCopyWithImpl<$Res, MyCredentialsPageState>;
  @useResult
  $Res call({List<DigitalCredential>? digitalCredentials, bool isLoading});
}

/// @nodoc
class _$MyCredentialsPageStateCopyWithImpl<$Res, $Val extends MyCredentialsPageState>
    implements $MyCredentialsPageStateCopyWith<$Res> {
  _$MyCredentialsPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyCredentialsPageState
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
abstract class _$$MyCredentialsPageStateImplCopyWith<$Res> implements $MyCredentialsPageStateCopyWith<$Res> {
  factory _$$MyCredentialsPageStateImplCopyWith(
          _$MyCredentialsPageStateImpl value, $Res Function(_$MyCredentialsPageStateImpl) then) =
      __$$MyCredentialsPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DigitalCredential>? digitalCredentials, bool isLoading});
}

/// @nodoc
class __$$MyCredentialsPageStateImplCopyWithImpl<$Res>
    extends _$MyCredentialsPageStateCopyWithImpl<$Res, _$MyCredentialsPageStateImpl>
    implements _$$MyCredentialsPageStateImplCopyWith<$Res> {
  __$$MyCredentialsPageStateImplCopyWithImpl(
      _$MyCredentialsPageStateImpl _value, $Res Function(_$MyCredentialsPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MyCredentialsPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? digitalCredentials = freezed,
    Object? isLoading = null,
  }) {
    return _then(_$MyCredentialsPageStateImpl(
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

class _$MyCredentialsPageStateImpl implements _MyCredentialsPageState {
  _$MyCredentialsPageStateImpl({final List<DigitalCredential>? digitalCredentials, this.isLoading = false})
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
    return 'MyCredentialsPageState(digitalCredentials: $digitalCredentials, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyCredentialsPageStateImpl &&
            const DeepCollectionEquality().equals(other._digitalCredentials, _digitalCredentials) &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(_digitalCredentials), isLoading);

  /// Create a copy of MyCredentialsPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyCredentialsPageStateImplCopyWith<_$MyCredentialsPageStateImpl> get copyWith =>
      __$$MyCredentialsPageStateImplCopyWithImpl<_$MyCredentialsPageStateImpl>(this, _$identity);
}

abstract class _MyCredentialsPageState implements MyCredentialsPageState {
  factory _MyCredentialsPageState({final List<DigitalCredential>? digitalCredentials, final bool isLoading}) =
      _$MyCredentialsPageStateImpl;

  @override
  List<DigitalCredential>? get digitalCredentials;
  @override
  bool get isLoading;

  /// Create a copy of MyCredentialsPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyCredentialsPageStateImplCopyWith<_$MyCredentialsPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
