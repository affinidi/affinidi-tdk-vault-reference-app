import 'package:freezed_annotation/freezed_annotation.dart';

part 'open_vault_params.freezed.dart';
part 'open_vault_params.g.dart';

@Freezed(toJson: true, fromJson: true)
class OpenVaultParams with _$OpenVaultParams {
  const factory OpenVaultParams({
    required String vaultId,
    required String base64Seed,
    required String vaultName,
    required String password,
  }) = _OpenVaultParams;

  factory OpenVaultParams.fromJson(Map<String, dynamic> json) => _$OpenVaultParamsFromJson(json);
}
