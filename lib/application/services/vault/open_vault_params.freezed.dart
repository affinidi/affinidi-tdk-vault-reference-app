// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'open_vault_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OpenVaultParams _$OpenVaultParamsFromJson(Map<String, dynamic> json) {
  return _OpenVaultParams.fromJson(json);
}

/// @nodoc
mixin _$OpenVaultParams {
  String get vaultId => throw _privateConstructorUsedError;
  String get base64Seed => throw _privateConstructorUsedError;
  String get vaultName => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this OpenVaultParams to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpenVaultParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenVaultParamsCopyWith<OpenVaultParams> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenVaultParamsCopyWith<$Res> {
  factory $OpenVaultParamsCopyWith(OpenVaultParams value, $Res Function(OpenVaultParams) then) =
      _$OpenVaultParamsCopyWithImpl<$Res, OpenVaultParams>;
  @useResult
  $Res call({String vaultId, String base64Seed, String vaultName, String password});
}

/// @nodoc
class _$OpenVaultParamsCopyWithImpl<$Res, $Val extends OpenVaultParams> implements $OpenVaultParamsCopyWith<$Res> {
  _$OpenVaultParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenVaultParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vaultId = null,
    Object? base64Seed = null,
    Object? vaultName = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      vaultId: null == vaultId
          ? _value.vaultId
          : vaultId // ignore: cast_nullable_to_non_nullable
              as String,
      base64Seed: null == base64Seed
          ? _value.base64Seed
          : base64Seed // ignore: cast_nullable_to_non_nullable
              as String,
      vaultName: null == vaultName
          ? _value.vaultName
          : vaultName // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpenVaultParamsImplCopyWith<$Res> implements $OpenVaultParamsCopyWith<$Res> {
  factory _$$OpenVaultParamsImplCopyWith(_$OpenVaultParamsImpl value, $Res Function(_$OpenVaultParamsImpl) then) =
      __$$OpenVaultParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String vaultId, String base64Seed, String vaultName, String password});
}

/// @nodoc
class __$$OpenVaultParamsImplCopyWithImpl<$Res> extends _$OpenVaultParamsCopyWithImpl<$Res, _$OpenVaultParamsImpl>
    implements _$$OpenVaultParamsImplCopyWith<$Res> {
  __$$OpenVaultParamsImplCopyWithImpl(_$OpenVaultParamsImpl _value, $Res Function(_$OpenVaultParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of OpenVaultParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vaultId = null,
    Object? base64Seed = null,
    Object? vaultName = null,
    Object? password = null,
  }) {
    return _then(_$OpenVaultParamsImpl(
      vaultId: null == vaultId
          ? _value.vaultId
          : vaultId // ignore: cast_nullable_to_non_nullable
              as String,
      base64Seed: null == base64Seed
          ? _value.base64Seed
          : base64Seed // ignore: cast_nullable_to_non_nullable
              as String,
      vaultName: null == vaultName
          ? _value.vaultName
          : vaultName // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpenVaultParamsImpl implements _OpenVaultParams {
  const _$OpenVaultParamsImpl(
      {required this.vaultId, required this.base64Seed, required this.vaultName, required this.password});

  factory _$OpenVaultParamsImpl.fromJson(Map<String, dynamic> json) => _$$OpenVaultParamsImplFromJson(json);

  @override
  final String vaultId;
  @override
  final String base64Seed;
  @override
  final String vaultName;
  @override
  final String password;

  @override
  String toString() {
    return 'OpenVaultParams(vaultId: $vaultId, base64Seed: $base64Seed, vaultName: $vaultName, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenVaultParamsImpl &&
            (identical(other.vaultId, vaultId) || other.vaultId == vaultId) &&
            (identical(other.base64Seed, base64Seed) || other.base64Seed == base64Seed) &&
            (identical(other.vaultName, vaultName) || other.vaultName == vaultName) &&
            (identical(other.password, password) || other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, vaultId, base64Seed, vaultName, password);

  /// Create a copy of OpenVaultParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenVaultParamsImplCopyWith<_$OpenVaultParamsImpl> get copyWith =>
      __$$OpenVaultParamsImplCopyWithImpl<_$OpenVaultParamsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpenVaultParamsImplToJson(
      this,
    );
  }
}

abstract class _OpenVaultParams implements OpenVaultParams {
  const factory _OpenVaultParams(
      {required final String vaultId,
      required final String base64Seed,
      required final String vaultName,
      required final String password}) = _$OpenVaultParamsImpl;

  factory _OpenVaultParams.fromJson(Map<String, dynamic> json) = _$OpenVaultParamsImpl.fromJson;

  @override
  String get vaultId;
  @override
  String get base64Seed;
  @override
  String get vaultName;
  @override
  String get password;

  /// Create a copy of OpenVaultParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenVaultParamsImplCopyWith<_$OpenVaultParamsImpl> get copyWith => throw _privateConstructorUsedError;
}
