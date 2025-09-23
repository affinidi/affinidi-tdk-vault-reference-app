// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vaults_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VaultsPageState {
  Map<String, Vault> get vaultsById => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of VaultsPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaultsPageStateCopyWith<VaultsPageState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaultsPageStateCopyWith<$Res> {
  factory $VaultsPageStateCopyWith(VaultsPageState value, $Res Function(VaultsPageState) then) =
      _$VaultsPageStateCopyWithImpl<$Res, VaultsPageState>;
  @useResult
  $Res call({Map<String, Vault> vaultsById, bool isLoading, String? errorMessage});
}

/// @nodoc
class _$VaultsPageStateCopyWithImpl<$Res, $Val extends VaultsPageState> implements $VaultsPageStateCopyWith<$Res> {
  _$VaultsPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaultsPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vaultsById = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      vaultsById: null == vaultsById
          ? _value.vaultsById
          : vaultsById // ignore: cast_nullable_to_non_nullable
              as Map<String, Vault>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VaultsPageStateImplCopyWith<$Res> implements $VaultsPageStateCopyWith<$Res> {
  factory _$$VaultsPageStateImplCopyWith(_$VaultsPageStateImpl value, $Res Function(_$VaultsPageStateImpl) then) =
      __$$VaultsPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, Vault> vaultsById, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$$VaultsPageStateImplCopyWithImpl<$Res> extends _$VaultsPageStateCopyWithImpl<$Res, _$VaultsPageStateImpl>
    implements _$$VaultsPageStateImplCopyWith<$Res> {
  __$$VaultsPageStateImplCopyWithImpl(_$VaultsPageStateImpl _value, $Res Function(_$VaultsPageStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of VaultsPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vaultsById = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$VaultsPageStateImpl(
      vaultsById: null == vaultsById
          ? _value._vaultsById
          : vaultsById // ignore: cast_nullable_to_non_nullable
              as Map<String, Vault>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$VaultsPageStateImpl implements _VaultsPageState {
  const _$VaultsPageStateImpl(
      {final Map<String, Vault> vaultsById = const {}, this.isLoading = false, this.errorMessage})
      : _vaultsById = vaultsById;

  final Map<String, Vault> _vaultsById;
  @override
  @JsonKey()
  Map<String, Vault> get vaultsById {
    if (_vaultsById is EqualUnmodifiableMapView) return _vaultsById;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_vaultsById);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'VaultsPageState(vaultsById: $vaultsById, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaultsPageStateImpl &&
            const DeepCollectionEquality().equals(other._vaultsById, _vaultsById) &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_vaultsById), isLoading, errorMessage);

  /// Create a copy of VaultsPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaultsPageStateImplCopyWith<_$VaultsPageStateImpl> get copyWith =>
      __$$VaultsPageStateImplCopyWithImpl<_$VaultsPageStateImpl>(this, _$identity);
}

abstract class _VaultsPageState implements VaultsPageState {
  const factory _VaultsPageState(
      {final Map<String, Vault> vaultsById, final bool isLoading, final String? errorMessage}) = _$VaultsPageStateImpl;

  @override
  Map<String, Vault> get vaultsById;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of VaultsPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaultsPageStateImplCopyWith<_$VaultsPageStateImpl> get copyWith => throw _privateConstructorUsedError;
}
