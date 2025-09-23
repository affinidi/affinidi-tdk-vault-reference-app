// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rename_folder_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RenameFolderFormState {
  bool get isRenameButtonEnabled => throw _privateConstructorUsedError;

  /// Create a copy of RenameFolderFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RenameFolderFormStateCopyWith<RenameFolderFormState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RenameFolderFormStateCopyWith<$Res> {
  factory $RenameFolderFormStateCopyWith(RenameFolderFormState value, $Res Function(RenameFolderFormState) then) =
      _$RenameFolderFormStateCopyWithImpl<$Res, RenameFolderFormState>;
  @useResult
  $Res call({bool isRenameButtonEnabled});
}

/// @nodoc
class _$RenameFolderFormStateCopyWithImpl<$Res, $Val extends RenameFolderFormState>
    implements $RenameFolderFormStateCopyWith<$Res> {
  _$RenameFolderFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RenameFolderFormState
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
abstract class _$$RenameFolderFormStateImplCopyWith<$Res> implements $RenameFolderFormStateCopyWith<$Res> {
  factory _$$RenameFolderFormStateImplCopyWith(
          _$RenameFolderFormStateImpl value, $Res Function(_$RenameFolderFormStateImpl) then) =
      __$$RenameFolderFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isRenameButtonEnabled});
}

/// @nodoc
class __$$RenameFolderFormStateImplCopyWithImpl<$Res>
    extends _$RenameFolderFormStateCopyWithImpl<$Res, _$RenameFolderFormStateImpl>
    implements _$$RenameFolderFormStateImplCopyWith<$Res> {
  __$$RenameFolderFormStateImplCopyWithImpl(
      _$RenameFolderFormStateImpl _value, $Res Function(_$RenameFolderFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RenameFolderFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRenameButtonEnabled = null,
  }) {
    return _then(_$RenameFolderFormStateImpl(
      isRenameButtonEnabled: null == isRenameButtonEnabled
          ? _value.isRenameButtonEnabled
          : isRenameButtonEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RenameFolderFormStateImpl implements _RenameFolderFormState {
  _$RenameFolderFormStateImpl({required this.isRenameButtonEnabled});

  @override
  final bool isRenameButtonEnabled;

  @override
  String toString() {
    return 'RenameFolderFormState(isRenameButtonEnabled: $isRenameButtonEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RenameFolderFormStateImpl &&
            (identical(other.isRenameButtonEnabled, isRenameButtonEnabled) ||
                other.isRenameButtonEnabled == isRenameButtonEnabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isRenameButtonEnabled);

  /// Create a copy of RenameFolderFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RenameFolderFormStateImplCopyWith<_$RenameFolderFormStateImpl> get copyWith =>
      __$$RenameFolderFormStateImplCopyWithImpl<_$RenameFolderFormStateImpl>(this, _$identity);
}

abstract class _RenameFolderFormState implements RenameFolderFormState {
  factory _RenameFolderFormState({required final bool isRenameButtonEnabled}) = _$RenameFolderFormStateImpl;

  @override
  bool get isRenameButtonEnabled;

  /// Create a copy of RenameFolderFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RenameFolderFormStateImplCopyWith<_$RenameFolderFormStateImpl> get copyWith => throw _privateConstructorUsedError;
}
