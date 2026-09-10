import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/vault/vault_service.dart';
import '../../../application/services/vaults_manager/vaults_manager_service.dart';
import 'vaults_page_state.dart';

part 'vaults_page_controller.g.dart';

@Riverpod(keepAlive: false)
class VaultsPageController extends _$VaultsPageController {
  @override
  VaultsPageState build() {
    Future.microtask(() => _loadVaults());
    return const VaultsPageState();
  }

  Future<void> _loadVaults() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final vaultsManagerService =
        ref.read(vaultsManagerServiceProvider.notifier);
    await vaultsManagerService.loadVaults();

    state = state.copyWith(
      isLoading: false,
      errorMessage: ref.read(vaultsManagerServiceProvider).errorMessage,
    );
  }

  Future<void> deleteVault(String vaultId) async {
    log('Deleting vault: $vaultId');
    await ref.read(vaultServiceProvider.notifier).deleteVault(vaultId);
    await _loadVaults();
  }

  Future<void> selectVault(String vaultId) async {
    log('Select vault: $vaultId');
    final vaultService = ref.read(vaultServiceProvider.notifier);
    await vaultService.resetCurrentVault();
  }
}
