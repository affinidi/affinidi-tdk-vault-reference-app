import 'dart:convert';
import 'dart:developer';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
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

    // Load available vaults
    final vaultsManagerService = ref.read(vaultsManagerServiceProvider.notifier);
    await vaultsManagerService.loadVaults();

    final vaultService = ref.read(vaultServiceProvider.notifier);
    final registry = ref.read(vaultsManagerServiceProvider).vaultRegistry;

    final Map<String, Vault> results = {};

    for (final entry in registry.entries) {
      final base64Seed = entry.value.base64Seed;
      try {
        final vaultId = entry.value.vaultId;
        final vault = await vaultService.getVaultFromSecureStorage(
          vaultStorageKey: vaultId,
          seed: base64Decode(base64Seed),
        );
        results[vaultId] = vault;
      } catch (e) {
        log('Failed to load vault [$entry.value.vaultId]: $e');
      }
    }
    state = state.copyWith(vaultsById: results, isLoading: false);
  }

  Future<void> deleteVault(String vaultId) async {
    log('Deleting vault: $vaultId');
    await ref.read(vaultsManagerServiceProvider.notifier).removeVault(
          vaultId,
        );
    await _loadVaults();
  }

  Future<void> selectVault(String vaultId) async {
    log('Select vault: $vaultId');
    final vaultService = ref.read(vaultServiceProvider.notifier);
    vaultService.resetCurrentVault();
  }

  void addVault(String vaultId, Vault vault) {
    state = state.copyWith(
      vaultsById: {...state.vaultsById, vaultId: vault},
    );
  }
}
