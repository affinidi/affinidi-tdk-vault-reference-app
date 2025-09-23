// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_vault_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CreateVaultPageState {
  SeedMode get seedMode => throw _privateConstructorUsedError;
  bool get isFormValid => throw _privateConstructorUsedError;

  /// Create a copy of CreateVaultPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateVaultPageStateCopyWith<CreateVaultPageState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateVaultPageStateCopyWith<$Res> {
  factory $CreateVaultPageStateCopyWith(CreateVaultPageState value, $Res Function(CreateVaultPageState) then) =
      _$CreateVaultPageStateCopyWithImpl<$Res, CreateVaultPageState>;
  @useResult
  $Res call({SeedMode seedMode, bool isFormValid});
}

/// @nodoc
class _$CreateVaultPageStateCopyWithImpl<$Res, $Val extends CreateVaultPageState>
    implements $CreateVaultPageStateCopyWith<$Res> {
  _$CreateVaultPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateVaultPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seedMode = null,
    Object? isFormValid = null,
  }) {
    return _then(_value.copyWith(
      seedMode: null == seedMode
          ? _value.seedMode
          : seedMode // ignore: cast_nullable_to_non_nullable
              as SeedMode,
      isFormValid: null == isFormValid
          ? _value.isFormValid
          : isFormValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateVaultPageStateImplCopyWith<$Res> implements $CreateVaultPageStateCopyWith<$Res> {
  factory _$$CreateVaultPageStateImplCopyWith(
          _$CreateVaultPageStateImpl value, $Res Function(_$CreateVaultPageStateImpl) then) =
      __$$CreateVaultPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SeedMode seedMode, bool isFormValid});
}

/// @nodoc
class __$$CreateVaultPageStateImplCopyWithImpl<$Res>
    extends _$CreateVaultPageStateCopyWithImpl<$Res, _$CreateVaultPageStateImpl>
    implements _$$CreateVaultPageStateImplCopyWith<$Res> {
  __$$CreateVaultPageStateImplCopyWithImpl(
      _$CreateVaultPageStateImpl _value, $Res Function(_$CreateVaultPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateVaultPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seedMode = null,
    Object? isFormValid = null,
  }) {
    return _then(_$CreateVaultPageStateImpl(
      seedMode: null == seedMode
          ? _value.seedMode
          : seedMode // ignore: cast_nullable_to_non_nullable
              as SeedMode,
      isFormValid: null == isFormValid
          ? _value.isFormValid
          : isFormValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CreateVaultPageStateImpl extends _CreateVaultPageState {
  const _$CreateVaultPageStateImpl({this.seedMode = SeedMode.generate, this.isFormValid = false}) : super._();

  @override
  @JsonKey()
  final SeedMode seedMode;
  @override
  @JsonKey()
  final bool isFormValid;

  @override
  String toString() {
    return 'CreateVaultPageState(seedMode: $seedMode, isFormValid: $isFormValid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateVaultPageStateImpl &&
            (identical(other.seedMode, seedMode) || other.seedMode == seedMode) &&
            (identical(other.isFormValid, isFormValid) || other.isFormValid == isFormValid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, seedMode, isFormValid);

  /// Create a copy of CreateVaultPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateVaultPageStateImplCopyWith<_$CreateVaultPageStateImpl> get copyWith =>
      __$$CreateVaultPageStateImplCopyWithImpl<_$CreateVaultPageStateImpl>(this, _$identity);
}

abstract class _CreateVaultPageState extends CreateVaultPageState {
  const factory _CreateVaultPageState({final SeedMode seedMode, final bool isFormValid}) = _$CreateVaultPageStateImpl;
  const _CreateVaultPageState._() : super._();

  @override
  SeedMode get seedMode;
  @override
  bool get isFormValid;

  /// Create a copy of CreateVaultPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateVaultPageStateImplCopyWith<_$CreateVaultPageStateImpl> get copyWith => throw _privateConstructorUsedError;
}
