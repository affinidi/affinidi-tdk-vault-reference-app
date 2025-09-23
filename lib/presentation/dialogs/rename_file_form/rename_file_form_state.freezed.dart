// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rename_file_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RenameFileFormState {
  bool get isRenameButtonEnabled => throw _privateConstructorUsedError;

  /// Create a copy of RenameFileFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RenameFileFormStateCopyWith<RenameFileFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RenameFileFormStateCopyWith<$Res> {
  factory $RenameFileFormStateCopyWith(
          RenameFileFormState value, $Res Function(RenameFileFormState) then) =
      _$RenameFileFormStateCopyWithImpl<$Res, RenameFileFormState>;
  @useResult
  $Res call({bool isRenameButtonEnabled});
}

/// @nodoc
class _$RenameFileFormStateCopyWithImpl<$Res, $Val extends RenameFileFormState>
    implements $RenameFileFormStateCopyWith<$Res> {
  _$RenameFileFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RenameFileFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRenameButtonEnabled = null,
  }) {
    return _then(_value.copyWith(
      isRenameButtonEnabled: null == isRenameButtonEnabled
          ? _value.isRenameButtonEnabled
          : isRenameButtonEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RenameFileFormStateImplCopyWith<$Res>
    implements $RenameFileFormStateCopyWith<$Res> {
  factory _$$RenameFileFormStateImplCopyWith(_$RenameFileFormStateImpl value,
          $Res Function(_$RenameFileFormStateImpl) then) =
      __$$RenameFileFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isRenameButtonEnabled});
}

/// @nodoc
class __$$RenameFileFormStateImplCopyWithImpl<$Res>
    extends _$RenameFileFormStateCopyWithImpl<$Res, _$RenameFileFormStateImpl>
    implements _$$RenameFileFormStateImplCopyWith<$Res> {
  __$$RenameFileFormStateImplCopyWithImpl(_$RenameFileFormStateImpl _value,
      $Res Function(_$RenameFileFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RenameFileFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRenameButtonEnabled = null,
  }) {
    return _then(_$RenameFileFormStateImpl(
      isRenameButtonEnabled: null == isRenameButtonEnabled
          ? _value.isRenameButtonEnabled
          : isRenameButtonEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RenameFileFormStateImpl implements _RenameFileFormState {
  _$RenameFileFormStateImpl({required this.isRenameButtonEnabled});

  @override
  final bool isRenameButtonEnabled;

  @override
  String toString() {
    return 'RenameFileFormState(isRenameButtonEnabled: $isRenameButtonEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RenameFileFormStateImpl &&
            (identical(other.isRenameButtonEnabled, isRenameButtonEnabled) ||
                other.isRenameButtonEnabled == isRenameButtonEnabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isRenameButtonEnabled);

  /// Create a copy of RenameFileFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RenameFileFormStateImplCopyWith<_$RenameFileFormStateImpl> get copyWith =>
      __$$RenameFileFormStateImplCopyWithImpl<_$RenameFileFormStateImpl>(
          this, _$identity);
}

abstract class _RenameFileFormState implements RenameFileFormState {
  factory _RenameFileFormState({required final bool isRenameButtonEnabled}) =
      _$RenameFileFormStateImpl;

  @override
  bool get isRenameButtonEnabled;

  /// Create a copy of RenameFileFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RenameFileFormStateImplCopyWith<_$RenameFileFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
