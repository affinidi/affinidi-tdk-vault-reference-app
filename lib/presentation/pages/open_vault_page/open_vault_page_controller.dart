import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/vault/vault_service.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../navigation/flows/profiles/profiles_route_constants.dart';
import '../../../navigation/navigation_provider.dart';

part 'open_vault_page_controller.g.dart';

@riverpod
class OpenVaultPageController extends _$OpenVaultPageController {
  OpenVaultPageController() : super();

  @override
  bool build() {
    return false;
  }

  Future<void> openVault({
    required String vaultId,
    required String password,
    required void Function() onSuccess,
    required void Function(String errorMessage) onError,
  }) async {
    state = true;
    try {
      await ref.read(vaultServiceProvider.notifier).open(
            password: password,
            vaultId: vaultId,
          );
      onSuccess.call();
    } catch (e, st) {
      String errorMessage = 'An error occurred while opening the vault';

      if (e is AppException) {
        switch (e.type) {
          case AppExceptionType.invalidPassword:
            errorMessage = 'Incorrect passphrase';
            break;
          case AppExceptionType.invalidVaultId:
            errorMessage = 'Vault not found';
            break;
          case AppExceptionType.seedNotFound:
            errorMessage = 'Vault data not found';
            break;
          default:
            errorMessage = e.message;
        }
      }

      onError.call(errorMessage);
      log('Vault open failed: $e\n$st', name: 'VaultLoader');
    } finally {
      state = false;
    }
  }

  void goToVaultsPage() {
    final navigation = ref.read(navigationServiceProvider);
    navigation.go(ProfilesRoutePath.base);
  }
}
