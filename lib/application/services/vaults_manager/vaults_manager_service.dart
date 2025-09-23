import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../vault/open_vault_params.dart';
import 'vaults_manager_state.dart';

part 'vaults_manager_service.g.dart';

const _vaultSeedMapKey = 'vault_registry_map';

@Riverpod(keepAlive: true)
class VaultsManagerService extends _$VaultsManagerService {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  @override
  VaultsManagerState build() {
    return const VaultsManagerState(isVaultAvailable: false);
  }

  Future<void> loadVaults() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    log('Loading vaults from secure storage...', name: 'VaultsManagerService');
    try {
      final seedJson = await _storage.read(key: _vaultSeedMapKey);
      if (seedJson == null) return;

      final Map<String, dynamic> raw = jsonDecode(seedJson);
      final Map<String, OpenVaultParams> result = raw.map((key, value) {
        return MapEntry(key, OpenVaultParams.fromJson(value));
      });

      log('Loaded ${raw.length} vault(s)', name: 'VaultsManagerService');
      state = state.copyWith(
        vaultRegistry: result,
        isVaultAvailable: result.isNotEmpty,
        isLoading: false,
      );
    } catch (e, stack) {
      log('Failed to load vaults: $e', name: 'VaultsManagerService', error: e, stackTrace: stack);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load vaults: $e',
      );
    }
  }

  Future<void> loadVaultAvailability() async {
    log('Checking vault availability...', name: 'VaultsManagerService');

    await ref.read(vaultsManagerServiceProvider.notifier).loadVaults();
    final available = state.vaultRegistry.isNotEmpty;
    log('Vaults available: $available', name: 'VaultsManagerService');
    state = state.copyWith(isVaultAvailable: available);
  }

  Future<void> addVault(OpenVaultParams vault) async {
    final vaultId = vault.vaultId;

    final raw = await _storage.read(key: _vaultSeedMapKey);
    final Map<String, dynamic> vaultMap = raw != null ? jsonDecode(raw) : {};

    if (!vaultMap.containsKey(vaultId)) {
      vaultMap[vaultId] = {
        'vaultId': vault.vaultId,
        'vaultName': vault.vaultName,
        'password': vault.password,
        'base64Seed': vault.base64Seed,
      };

      await _storage.write(key: _vaultSeedMapKey, value: jsonEncode(vaultMap));
      state = state.copyWith(isVaultAvailable: true);
      log('Added vault (vaultId: $vaultId)', name: 'VaultsManagerService');
    } else {
      log('Vault already exists for vaultId: $vaultId', name: 'VaultsManagerService');
    }
  }

  Future<void> removeVault(String vaultId) async {
    final raw = await _storage.read(key: _vaultSeedMapKey);
    final Map<String, dynamic> vaultMap = raw != null ? jsonDecode(raw) : {};

    if (vaultMap.containsKey(vaultId)) {
      vaultMap.remove(vaultId);
      await _storage.write(key: _vaultSeedMapKey, value: jsonEncode(vaultMap));
      log('Removed vault with vaultId: $vaultId', name: 'VaultsManagerService');

      final updatedRegistry = Map<String, OpenVaultParams>.from(state.vaultRegistry)..remove(vaultId);
      state = state.copyWith(vaultRegistry: updatedRegistry);
    } else {
      log('No vault found for vaultId: $vaultId', name: 'VaultsManagerService');
    }
  }

  Future<void> clearVaults() async {
    await _storage.delete(key: _vaultSeedMapKey);
    log('Cleared all vaults');
    state = state.copyWith(vaultRegistry: {});
  }
}
