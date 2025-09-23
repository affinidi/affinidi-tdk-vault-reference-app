// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_profile_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CreateProfileFormState {
  bool get hasName => throw _privateConstructorUsedError;
  bool get hasDescription => throw _privateConstructorUsedError;
  ProfileType get selectedProfileType => throw _privateConstructorUsedError;

  /// Create a copy of CreateProfileFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateProfileFormStateCopyWith<CreateProfileFormState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateProfileFormStateCopyWith<$Res> {
  factory $CreateProfileFormStateCopyWith(CreateProfileFormState value, $Res Function(CreateProfileFormState) then) =
      _$CreateProfileFormStateCopyWithImpl<$Res, CreateProfileFormState>;
  @useResult
  $Res call({bool hasName, bool hasDescription, ProfileType selectedProfileType});
}

/// @nodoc
class _$CreateProfileFormStateCopyWithImpl<$Res, $Val extends CreateProfileFormState>
    implements $CreateProfileFormStateCopyWith<$Res> {
  _$CreateProfileFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateProfileFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasName = null,
    Object? hasDescription = null,
    Object? selectedProfileType = null,
  }) {
    return _then(_value.copyWith(
      hasName: null == hasName
          ? _value.hasName
          : hasName // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDescription: null == hasDescription
          ? _value.hasDescription
          : hasDescription // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedProfileType: null == selectedProfileType
          ? _value.selectedProfileType
          : selectedProfileType // ignore: cast_nullable_to_non_nullable
              as ProfileType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateProfileFormStateImplCopyWith<$Res> implements $CreateProfileFormStateCopyWith<$Res> {
  factory _$$CreateProfileFormStateImplCopyWith(
          _$CreateProfileFormStateImpl value, $Res Function(_$CreateProfileFormStateImpl) then) =
      __$$CreateProfileFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool hasName, bool hasDescription, ProfileType selectedProfileType});
}

/// @nodoc
class __$$CreateProfileFormStateImplCopyWithImpl<$Res>
    extends _$CreateProfileFormStateCopyWithImpl<$Res, _$CreateProfileFormStateImpl>
    implements _$$CreateProfileFormStateImplCopyWith<$Res> {
  __$$CreateProfileFormStateImplCopyWithImpl(
      _$CreateProfileFormStateImpl _value, $Res Function(_$CreateProfileFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateProfileFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasName = null,
    Object? hasDescription = null,
    Object? selectedProfileType = null,
  }) {
    return _then(_$CreateProfileFormStateImpl(
      hasName: null == hasName
          ? _value.hasName
          : hasName // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDescription: null == hasDescription
          ? _value.hasDescription
          : hasDescription // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedProfileType: null == selectedProfileType
          ? _value.selectedProfileType
          : selectedProfileType // ignore: cast_nullable_to_non_nullable
              as ProfileType,
    ));
  }
}

/// @nodoc

class _$CreateProfileFormStateImpl extends _CreateProfileFormState with DiagnosticableTreeMixin {
  _$CreateProfileFormStateImpl(
      {this.hasName = false, this.hasDescription = false, this.selectedProfileType = ProfileType.affinidiCloud})
      : super._();

  @override
  @JsonKey()
  final bool hasName;
  @override
  @JsonKey()
  final bool hasDescription;
  @override
  @JsonKey()
  final ProfileType selectedProfileType;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CreateProfileFormState(hasName: $hasName, hasDescription: $hasDescription, selectedProfileType: $selectedProfileType)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CreateProfileFormState'))
      ..add(DiagnosticsProperty('hasName', hasName))
      ..add(DiagnosticsProperty('hasDescription', hasDescription))
      ..add(DiagnosticsProperty('selectedProfileType', selectedProfileType));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateProfileFormStateImpl &&
            (identical(other.hasName, hasName) || other.hasName == hasName) &&
            (identical(other.hasDescription, hasDescription) || other.hasDescription == hasDescription) &&
            (identical(other.selectedProfileType, selectedProfileType) ||
                other.selectedProfileType == selectedProfileType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hasName, hasDescription, selectedProfileType);

  /// Create a copy of CreateProfileFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateProfileFormStateImplCopyWith<_$CreateProfileFormStateImpl> get copyWith =>
      __$$CreateProfileFormStateImplCopyWithImpl<_$CreateProfileFormStateImpl>(this, _$identity);
}

abstract class _CreateProfileFormState extends CreateProfileFormState {
  factory _CreateProfileFormState(
      {final bool hasName,
      final bool hasDescription,
      final ProfileType selectedProfileType}) = _$CreateProfileFormStateImpl;
  _CreateProfileFormState._() : super._();

  @override
  bool get hasName;
  @override
  bool get hasDescription;
  @override
  ProfileType get selectedProfileType;

  /// Create a copy of CreateProfileFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateProfileFormStateImplCopyWith<_$CreateProfileFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
