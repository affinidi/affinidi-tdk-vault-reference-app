import 'package:freezed_annotation/freezed_annotation.dart';

import '../vault/open_vault_params.dart';

part 'vaults_manager_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class VaultsManagerState with _$VaultsManagerState {
  const factory VaultsManagerState({
    @Default({}) Map<String, OpenVaultParams> vaultRegistry,
    @Default(false) bool isLoading,
    @Default(false) bool isVaultAvailable,
    String? errorMessage,
  }) = _VaultsManagerState;
}
