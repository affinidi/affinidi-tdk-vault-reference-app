// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_folder_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CreateFolderFormState {
  bool get isCreateFolderButtonEnabled => throw _privateConstructorUsedError;

  /// Create a copy of CreateFolderFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateFolderFormStateCopyWith<CreateFolderFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateFolderFormStateCopyWith<$Res> {
  factory $CreateFolderFormStateCopyWith(CreateFolderFormState value,
          $Res Function(CreateFolderFormState) then) =
      _$CreateFolderFormStateCopyWithImpl<$Res, CreateFolderFormState>;
  @useResult
  $Res call({bool isCreateFolderButtonEnabled});
}

/// @nodoc
class _$CreateFolderFormStateCopyWithImpl<$Res,
        $Val extends CreateFolderFormState>
    implements $CreateFolderFormStateCopyWith<$Res> {
  _$CreateFolderFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateFolderFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCreateFolderButtonEnabled = null,
  }) {
    return _then(_value.copyWith(
      isCreateFolderButtonEnabled: null == isCreateFolderButtonEnabled
          ? _value.isCreateFolderButtonEnabled
          : isCreateFolderButtonEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateFolderFormStateImplCopyWith<$Res>
    implements $CreateFolderFormStateCopyWith<$Res> {
  factory _$$CreateFolderFormStateImplCopyWith(
          _$CreateFolderFormStateImpl value,
          $Res Function(_$CreateFolderFormStateImpl) then) =
      __$$CreateFolderFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isCreateFolderButtonEnabled});
}

/// @nodoc
class __$$CreateFolderFormStateImplCopyWithImpl<$Res>
    extends _$CreateFolderFormStateCopyWithImpl<$Res,
        _$CreateFolderFormStateImpl>
    implements _$$CreateFolderFormStateImplCopyWith<$Res> {
  __$$CreateFolderFormStateImplCopyWithImpl(_$CreateFolderFormStateImpl _value,
      $Res Function(_$CreateFolderFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateFolderFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCreateFolderButtonEnabled = null,
  }) {
    return _then(_$CreateFolderFormStateImpl(
      isCreateFolderButtonEnabled: null == isCreateFolderButtonEnabled
          ? _value.isCreateFolderButtonEnabled
          : isCreateFolderButtonEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CreateFolderFormStateImpl implements _CreateFolderFormState {
  _$CreateFolderFormStateImpl({required this.isCreateFolderButtonEnabled});

  @override
  final bool isCreateFolderButtonEnabled;

  @override
  String toString() {
    return 'CreateFolderFormState(isCreateFolderButtonEnabled: $isCreateFolderButtonEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateFolderFormStateImpl &&
            (identical(other.isCreateFolderButtonEnabled,
                    isCreateFolderButtonEnabled) ||
                other.isCreateFolderButtonEnabled ==
                    isCreateFolderButtonEnabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isCreateFolderButtonEnabled);

  /// Create a copy of CreateFolderFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateFolderFormStateImplCopyWith<_$CreateFolderFormStateImpl>
      get copyWith => __$$CreateFolderFormStateImplCopyWithImpl<
          _$CreateFolderFormStateImpl>(this, _$identity);
}

abstract class _CreateFolderFormState implements CreateFolderFormState {
  factory _CreateFolderFormState(
          {required final bool isCreateFolderButtonEnabled}) =
      _$CreateFolderFormStateImpl;

  @override
  bool get isCreateFolderButtonEnabled;

  /// Create a copy of CreateFolderFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateFolderFormStateImplCopyWith<_$CreateFolderFormStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
