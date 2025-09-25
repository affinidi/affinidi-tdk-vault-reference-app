// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'claim_credential_service_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ClaimCredentialServiceState {
  OID4VCIClaimContext? get claimContext => throw _privateConstructorUsedError;
  VerifiableCredential? get verifiableCredential =>
      throw _privateConstructorUsedError;

  /// Create a copy of ClaimCredentialServiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClaimCredentialServiceStateCopyWith<ClaimCredentialServiceState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClaimCredentialServiceStateCopyWith<$Res> {
  factory $ClaimCredentialServiceStateCopyWith(
          ClaimCredentialServiceState value,
          $Res Function(ClaimCredentialServiceState) then) =
      _$ClaimCredentialServiceStateCopyWithImpl<$Res,
          ClaimCredentialServiceState>;
  @useResult
  $Res call(
      {OID4VCIClaimContext? claimContext,
      VerifiableCredential? verifiableCredential});
}

/// @nodoc
class _$ClaimCredentialServiceStateCopyWithImpl<$Res,
        $Val extends ClaimCredentialServiceState>
    implements $ClaimCredentialServiceStateCopyWith<$Res> {
  _$ClaimCredentialServiceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClaimCredentialServiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? claimContext = freezed,
    Object? verifiableCredential = freezed,
  }) {
    return _then(_value.copyWith(
      claimContext: freezed == claimContext
          ? _value.claimContext
          : claimContext // ignore: cast_nullable_to_non_nullable
              as OID4VCIClaimContext?,
      verifiableCredential: freezed == verifiableCredential
          ? _value.verifiableCredential
          : verifiableCredential // ignore: cast_nullable_to_non_nullable
              as VerifiableCredential?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClaimCredentialServiceStateImplCopyWith<$Res>
    implements $ClaimCredentialServiceStateCopyWith<$Res> {
  factory _$$ClaimCredentialServiceStateImplCopyWith(
          _$ClaimCredentialServiceStateImpl value,
          $Res Function(_$ClaimCredentialServiceStateImpl) then) =
      __$$ClaimCredentialServiceStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OID4VCIClaimContext? claimContext,
      VerifiableCredential? verifiableCredential});
}

/// @nodoc
class __$$ClaimCredentialServiceStateImplCopyWithImpl<$Res>
    extends _$ClaimCredentialServiceStateCopyWithImpl<$Res,
        _$ClaimCredentialServiceStateImpl>
    implements _$$ClaimCredentialServiceStateImplCopyWith<$Res> {
  __$$ClaimCredentialServiceStateImplCopyWithImpl(
      _$ClaimCredentialServiceStateImpl _value,
      $Res Function(_$ClaimCredentialServiceStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClaimCredentialServiceState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? claimContext = freezed,
    Object? verifiableCredential = freezed,
  }) {
    return _then(_$ClaimCredentialServiceStateImpl(
      claimContext: freezed == claimContext
          ? _value.claimContext
          : claimContext // ignore: cast_nullable_to_non_nullable
              as OID4VCIClaimContext?,
      verifiableCredential: freezed == verifiableCredential
          ? _value.verifiableCredential
          : verifiableCredential // ignore: cast_nullable_to_non_nullable
              as VerifiableCredential?,
    ));
  }
}

/// @nodoc

class _$ClaimCredentialServiceStateImpl
    implements _ClaimCredentialServiceState {
  _$ClaimCredentialServiceStateImpl(
      {this.claimContext, this.verifiableCredential});

  @override
  final OID4VCIClaimContext? claimContext;
  @override
  final VerifiableCredential? verifiableCredential;

  @override
  String toString() {
    return 'ClaimCredentialServiceState(claimContext: $claimContext, verifiableCredential: $verifiableCredential)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClaimCredentialServiceStateImpl &&
            (identical(other.claimContext, claimContext) ||
                other.claimContext == claimContext) &&
            (identical(other.verifiableCredential, verifiableCredential) ||
                other.verifiableCredential == verifiableCredential));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, claimContext, verifiableCredential);

  /// Create a copy of ClaimCredentialServiceState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClaimCredentialServiceStateImplCopyWith<_$ClaimCredentialServiceStateImpl>
      get copyWith => __$$ClaimCredentialServiceStateImplCopyWithImpl<
          _$ClaimCredentialServiceStateImpl>(this, _$identity);
}

abstract class _ClaimCredentialServiceState
    implements ClaimCredentialServiceState {
  factory _ClaimCredentialServiceState(
          {final OID4VCIClaimContext? claimContext,
          final VerifiableCredential? verifiableCredential}) =
      _$ClaimCredentialServiceStateImpl;

  @override
  OID4VCIClaimContext? get claimContext;
  @override
  VerifiableCredential? get verifiableCredential;

  /// Create a copy of ClaimCredentialServiceState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClaimCredentialServiceStateImplCopyWith<_$ClaimCredentialServiceStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
