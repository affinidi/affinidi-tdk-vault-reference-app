import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';

import '../../../application/services/vault/vault_service.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import '../../widgets/loading_status/async_loading_controller.dart';

import 'create_vault_page_state.dart';

part 'create_vault_page_controller.g.dart';

@riverpod
class CreateVaultPageController extends _$CreateVaultPageController {
  CreateVaultPageController() : super();

  final loadingController = AsyncLoadingController.provider('createVaultPageControllerLoading');

  @override
  CreateVaultPageState build() {
    log('Build', name: 'CreateVaultPageController');
    return const CreateVaultPageState();
  }

  Future<void> createVault({
    required String vaultName,
    required String password,
    String? seed,
    required void Function(Vault vault, String vaultId) onSuccess,
    required void Function({AppExceptionType? errorType}) onError,
  }) async {
    ref.read(loadingController.notifier).start(() async {
      try {
        final vaultService = ref.read(vaultServiceProvider.notifier);
        await vaultService.create(
          vaultName: vaultName,
          password: password,
          existingSeed: seed,
        );
        final vault = vaultService.state.currentVault;
        final vaultId = vaultService.state.currentVaultId;
        if (vault != null && vaultId != null) {
          onSuccess.call(vault, vaultId);
        } else {
          onError.call();
        }
      } catch (e) {
        log('Failed to create vault: $e', name: 'VaultService');
        if (e is AppException) {
          if (e.type == AppExceptionType.vaultAlreadyExists) {
            onError.call(errorType: e.type);
          }
        } else {
          onError.call();
        }
      }
    });
  }

  void updateSeedMode(SeedMode mode) {
    state = state.copyWith(seedMode: mode);
  }

  void validateForm({
    required String vaultName,
    required String password,
    required String seed,
    required SeedMode seedMode,
  }) {
    final nameFilled = vaultName.trim().isNotEmpty;
    final passFilled = password.trim().isNotEmpty;
    final usingExistingSeed = seedMode == SeedMode.useExisting;
    final seedFilled = seed.trim().isNotEmpty;

    // For random string input, only check if it's filled when using existing seed
    final seedValid = !usingExistingSeed || seedFilled;

    state = state.copyWith(isFormValid: nameFilled && passFilled && seedValid);
  }
}
