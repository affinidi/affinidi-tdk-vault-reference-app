// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vault_service_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VaultServiceState {
  Vault? get currentVault => throw _privateConstructorUsedError;
  String? get currentVaultId => throw _privateConstructorUsedError;

  /// Create a copy of VaultServiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaultServiceStateCopyWith<VaultServiceState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaultServiceStateCopyWith<$Res> {
  factory $VaultServiceStateCopyWith(VaultServiceState value, $Res Function(VaultServiceState) then) =
      _$VaultServiceStateCopyWithImpl<$Res, VaultServiceState>;
  @useResult
  $Res call({Vault? currentVault, String? currentVaultId});
}

/// @nodoc
class _$VaultServiceStateCopyWithImpl<$Res, $Val extends VaultServiceState>
    implements $VaultServiceStateCopyWith<$Res> {
  _$VaultServiceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaultServiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentVault = freezed,
    Object? currentVaultId = freezed,
  }) {
    return _then(_value.copyWith(
      currentVault: freezed == currentVault
          ? _value.currentVault
          : currentVault // ignore: cast_nullable_to_non_nullable
              as Vault?,
      currentVaultId: freezed == currentVaultId
          ? _value.currentVaultId
          : currentVaultId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VaultServiceStateImplCopyWith<$Res> implements $VaultServiceStateCopyWith<$Res> {
  factory _$$VaultServiceStateImplCopyWith(_$VaultServiceStateImpl value, $Res Function(_$VaultServiceStateImpl) then) =
      __$$VaultServiceStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Vault? currentVault, String? currentVaultId});
}

/// @nodoc
class __$$VaultServiceStateImplCopyWithImpl<$Res> extends _$VaultServiceStateCopyWithImpl<$Res, _$VaultServiceStateImpl>
    implements _$$VaultServiceStateImplCopyWith<$Res> {
  __$$VaultServiceStateImplCopyWithImpl(_$VaultServiceStateImpl _value, $Res Function(_$VaultServiceStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of VaultServiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentVault = freezed,
    Object? currentVaultId = freezed,
  }) {
    return _then(_$VaultServiceStateImpl(
      currentVault: freezed == currentVault
          ? _value.currentVault
          : currentVault // ignore: cast_nullable_to_non_nullable
              as Vault?,
      currentVaultId: freezed == currentVaultId
          ? _value.currentVaultId
          : currentVaultId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$VaultServiceStateImpl implements _VaultServiceState {
  _$VaultServiceStateImpl({this.currentVault, this.currentVaultId});

  @override
  final Vault? currentVault;
  @override
  final String? currentVaultId;

  @override
  String toString() {
    return 'VaultServiceState(currentVault: $currentVault, currentVaultId: $currentVaultId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaultServiceStateImpl &&
            (identical(other.currentVault, currentVault) || other.currentVault == currentVault) &&
            (identical(other.currentVaultId, currentVaultId) || other.currentVaultId == currentVaultId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentVault, currentVaultId);

  /// Create a copy of VaultServiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaultServiceStateImplCopyWith<_$VaultServiceStateImpl> get copyWith =>
      __$$VaultServiceStateImplCopyWithImpl<_$VaultServiceStateImpl>(this, _$identity);
}

abstract class _VaultServiceState implements VaultServiceState {
  factory _VaultServiceState({final Vault? currentVault, final String? currentVaultId}) = _$VaultServiceStateImpl;

  @override
  Vault? get currentVault;
  @override
  String? get currentVaultId;

  /// Create a copy of VaultServiceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaultServiceStateImplCopyWith<_$VaultServiceStateImpl> get copyWith => throw _privateConstructorUsedError;
}
