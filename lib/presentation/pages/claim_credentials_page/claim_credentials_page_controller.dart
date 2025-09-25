import 'dart:developer';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../application/services/credential/claim_credential_service.dart';
import '../../../application/services/credential/credential_service.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../navigation/flows/profiles/profiles_route_constants.dart';
import '../../../navigation/flows/vaults/vaults_route_constants.dart';
import '../../../navigation/navigation_provider.dart';
import '../../widgets/loading_status/async_loading_controller.dart';

import 'claim_credentials_page_state.dart';

part 'claim_credentials_page_controller.g.dart';

@riverpod
class ClaimCredentialsPageController extends _$ClaimCredentialsPageController {
  ClaimCredentialsPageController() : super();

  final loadingController =
      AsyncLoadingController.provider('loadingController');
  final savingController = AsyncLoadingController.provider('savingController');
  final validatingController =
      AsyncLoadingController.provider('validatingController');

  @override
  ClaimCredentialsPageState build({required String profileId}) {
    log('Build', name: 'ClaimCredentialsPageController');

    final provider = claimCredentialServiceProvider;

    ref.listen(provider.select((state) => state.claimContext),
        (previous, next) {
      Future(() {
        state = state.copyWith(claimContext: next);
      });
    }, fireImmediately: true);

    ref.listen(provider.select((state) => state.verifiableCredential),
        (previous, next) {
      Future(() {
        state = state.copyWith(verifiableCredential: next);
      });
    }, fireImmediately: true);

    return ClaimCredentialsPageState(profileId: profileId);
  }

  Future<void> fetchCredentialOffer(Uri uri) async {
    final vault = _getCurrentVault();

    final profiles = await vault.listProfiles();
    final profileIndex = profiles.indexWhere((p) => p.id == profileId);

    state = state.copyWith(
      offerUri: uri,
      fetchStatus: CredentialOfferFetchStatus.loading,
    );
    try {
      await ref
          .read(claimCredentialServiceProvider.notifier)
          .getCredentialOffer(
            uri,
            profileIndex + 1,
          );

      state = state.copyWith(
        fetchStatus: CredentialOfferFetchStatus.success,
      );
    } catch (e) {
      state = state.copyWith(
        fetchStatus: CredentialOfferFetchStatus.error,
      );
    }
  }

  Future<void> saveCredential({
    required void Function() onSuccess,
    required String profileId,
  }) async {
    final verifiableCredential = state.verifiableCredential;
    if (verifiableCredential == null) {
      Error.throwWithStackTrace(
          AppException(
            message: 'Cannot save credential as none was provided',
            type: AppExceptionType.missingVerifiableCredentials,
          ),
          StackTrace.current);
    }

    ref.read(savingController.notifier).start(() async => await ref
        .read(credentialServiceProvider(profileId: profileId).notifier)
        .saveCredential(
          verifiableCredential: verifiableCredential,
        )
        .then((_) => onSuccess()));
  }

  Future<String> getProfileDid() async {
    final vault = _getCurrentVault();

    final profiles = await vault.listProfiles();
    final profile = profiles.firstWhere((p) => p.id == profileId);
    return profile.did;
  }

  void retry() {
    state = state.copyWith(
      offerUri: null,
      fetchStatus: CredentialOfferFetchStatus.initial,
    );
  }

  void goToVaultsPage() {
    final navigation = ref.read(navigationServiceProvider);
    navigation.go(VaultsRoutePath.base);
  }

  void goToMyCredentialPage() {
    final navigation = ref.read(navigationServiceProvider);
    navigation.go(
      ProfilesRoutePath.profileMyCredentials(
        profileId,
      ),
    );
  }

  // Private helper methods

  /// Gets the current vault, throwing an exception if none is open.
  Vault _getCurrentVault() {
    log('Getting current vault...', name: 'ProfileService');
    final vaultServiceState = ref.read(vaultServiceProvider);
    log('Vault service state retrieved', name: 'ProfileService');
    final vault = vaultServiceState.currentVault;

    if (vault == null) {
      log('No vault found, throwing exception', name: 'ProfileService');
      throw AppException(
        message: 'You must open a Vault to perform this operation',
        type: AppExceptionType.other,
      );
    }

    log('Vault retrieved successfully', name: 'ProfileService');
    return vault;
  }
}
