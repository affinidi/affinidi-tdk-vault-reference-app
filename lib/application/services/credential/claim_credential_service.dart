import 'dart:async';
import 'dart:developer';

import 'package:affinidi_tdk_claim_verifiable_credential/oid4vci_claim_verifiable_credential.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../infrastructure/exceptions/app_exception.dart';

import '../../repositories/credential/claim_credential_repository_impl.dart';
import '../vault/vault_service.dart';
import 'claim_credential_service_state.dart';

part 'claim_credential_service.g.dart';

@riverpod
class ClaimCredentialService extends _$ClaimCredentialService {
  ClaimCredentialService() : super();

  @override
  ClaimCredentialServiceState build() {
    return ClaimCredentialServiceState();
  }

  Future<void> getCredentialOffer(
    Uri offerUri,
    int accountIndex,
  ) async {
    state = state.copyWith(claimContext: null, verifiableCredential: null);
    final vaultProvider = ref.read(vaultServiceProvider);

    final currentVaultId = vaultProvider.currentVaultId;
    if (currentVaultId == null) {
      throw AppException(
          message: 'No vault is currently open. Please open a vault first.', type: AppExceptionType.missingVaultId);
    }

    final claimCredentialRepository = await ref.read(
      claimCredentialRepositoryProvider(
        currentVaultId,
        accountIndex,
      ).future,
    );
    try {
      final claimContext = await claimCredentialRepository.getOID4VCIClaimContext(
        offerUri,
      );

      await claimCrendential(
        claimContext: claimContext,
        accountIndex: accountIndex,
      );
    } catch (e) {
      log('Error during claim credential: $e', name: 'ClaimCredentialService');
      rethrow;
    }
  }

  Future<void> claimCrendential({
    required OID4VCIClaimContext claimContext,
    required int accountIndex,
  }) async {
    try {
      final vaultProvider = ref.read(vaultServiceProvider);

      final currentVaultId = vaultProvider.currentVaultId;
      if (currentVaultId == null) {
        throw AppException(
            message: 'No vault is currently open. Please open a vault first.', type: AppExceptionType.missingVaultId);
      }

      final credentialRepository = await ref.read(claimCredentialRepositoryProvider(
        currentVaultId,
        accountIndex,
      ).future);
      final verifiableCredential = await credentialRepository.claimCredentials(
        claimContext: claimContext,
      );

      state = state.copyWith(verifiableCredential: verifiableCredential);
    } catch (e) {
      log('Error during claim credential: $e', name: 'ClaimCredentialService');
      rethrow;
    }
  }
}
