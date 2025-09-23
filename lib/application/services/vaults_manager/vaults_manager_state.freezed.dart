// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vaults_manager_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VaultsManagerState {
  Map<String, OpenVaultParams> get vaultRegistry => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isVaultAvailable => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of VaultsManagerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaultsManagerStateCopyWith<VaultsManagerState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaultsManagerStateCopyWith<$Res> {
  factory $VaultsManagerStateCopyWith(VaultsManagerState value, $Res Function(VaultsManagerState) then) =
      _$VaultsManagerStateCopyWithImpl<$Res, VaultsManagerState>;
  @useResult
  $Res call({Map<String, OpenVaultParams> vaultRegistry, bool isLoading, bool isVaultAvailable, String? errorMessage});
}

/// @nodoc
class _$VaultsManagerStateCopyWithImpl<$Res, $Val extends VaultsManagerState>
    implements $VaultsManagerStateCopyWith<$Res> {
  _$VaultsManagerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaultsManagerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vaultRegistry = null,
    Object? isLoading = null,
    Object? isVaultAvailable = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      vaultRegistry: null == vaultRegistry
          ? _value.vaultRegistry
          : vaultRegistry // ignore: cast_nullable_to_non_nullable
              as Map<String, OpenVaultParams>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isVaultAvailable: null == isVaultAvailable
          ? _value.isVaultAvailable
          : isVaultAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VaultsManagerStateImplCopyWith<$Res> implements $VaultsManagerStateCopyWith<$Res> {
  factory _$$VaultsManagerStateImplCopyWith(
          _$VaultsManagerStateImpl value, $Res Function(_$VaultsManagerStateImpl) then) =
      __$$VaultsManagerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, OpenVaultParams> vaultRegistry, bool isLoading, bool isVaultAvailable, String? errorMessage});
}

/// @nodoc
class __$$VaultsManagerStateImplCopyWithImpl<$Res>
    extends _$VaultsManagerStateCopyWithImpl<$Res, _$VaultsManagerStateImpl>
    implements _$$VaultsManagerStateImplCopyWith<$Res> {
  __$$VaultsManagerStateImplCopyWithImpl(_$VaultsManagerStateImpl _value, $Res Function(_$VaultsManagerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of VaultsManagerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vaultRegistry = null,
    Object? isLoading = null,
    Object? isVaultAvailable = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$VaultsManagerStateImpl(
      vaultRegistry: null == vaultRegistry
          ? _value._vaultRegistry
          : vaultRegistry // ignore: cast_nullable_to_non_nullable
              as Map<String, OpenVaultParams>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isVaultAvailable: null == isVaultAvailable
          ? _value.isVaultAvailable
          : isVaultAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$VaultsManagerStateImpl implements _VaultsManagerState {
  const _$VaultsManagerStateImpl(
      {final Map<String, OpenVaultParams> vaultRegistry = const {},
      this.isLoading = false,
      this.isVaultAvailable = false,
      this.errorMessage})
      : _vaultRegistry = vaultRegistry;

  final Map<String, OpenVaultParams> _vaultRegistry;
  @override
  @JsonKey()
  Map<String, OpenVaultParams> get vaultRegistry {
    if (_vaultRegistry is EqualUnmodifiableMapView) return _vaultRegistry;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_vaultRegistry);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isVaultAvailable;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'VaultsManagerState(vaultRegistry: $vaultRegistry, isLoading: $isLoading, isVaultAvailable: $isVaultAvailable, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaultsManagerStateImpl &&
            const DeepCollectionEquality().equals(other._vaultRegistry, _vaultRegistry) &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading) &&
            (identical(other.isVaultAvailable, isVaultAvailable) || other.isVaultAvailable == isVaultAvailable) &&
            (identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_vaultRegistry), isLoading, isVaultAvailable, errorMessage);

  /// Create a copy of VaultsManagerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaultsManagerStateImplCopyWith<_$VaultsManagerStateImpl> get copyWith =>
      __$$VaultsManagerStateImplCopyWithImpl<_$VaultsManagerStateImpl>(this, _$identity);
}

abstract class _VaultsManagerState implements VaultsManagerState {
  const factory _VaultsManagerState(
      {final Map<String, OpenVaultParams> vaultRegistry,
      final bool isLoading,
      final bool isVaultAvailable,
      final String? errorMessage}) = _$VaultsManagerStateImpl;

  @override
  Map<String, OpenVaultParams> get vaultRegistry;
  @override
  bool get isLoading;
  @override
  bool get isVaultAvailable;
  @override
  String? get errorMessage;

  /// Create a copy of VaultsManagerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaultsManagerStateImplCopyWith<_$VaultsManagerStateImpl> get copyWith => throw _privateConstructorUsedError;
}
