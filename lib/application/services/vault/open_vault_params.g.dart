// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_vault_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OpenVaultParamsImpl _$$OpenVaultParamsImplFromJson(Map<String, dynamic> json) => _$OpenVaultParamsImpl(
      vaultId: json['vaultId'] as String,
      base64Seed: json['base64Seed'] as String,
      vaultName: json['vaultName'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$OpenVaultParamsImplToJson(_$OpenVaultParamsImpl instance) => <String, dynamic>{
      'vaultId': instance.vaultId,
      'base64Seed': instance.base64Seed,
      'vaultName': instance.vaultName,
      'password': instance.password,
    };
