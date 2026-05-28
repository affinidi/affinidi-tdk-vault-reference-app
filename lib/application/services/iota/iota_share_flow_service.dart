import 'package:affinidi_tdk_cryptography/affinidi_tdk_cryptography.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../infrastructure/utils/constants.dart';
import 'app_iota_share_response_service.dart';

part 'iota_share_flow_service.g.dart';

@riverpod
ShareFlowServiceInterface iotaShareFlowService(Ref ref) {
  return ShareFlowService(cryptography: CryptographyService());
}

@riverpod
PDClassifier iotaPdClassifier(Ref ref) {
  // validIdvIssuers: trusted IDV issuer DIDs — empty for now (no IDV routing).
  return PDClassifier(validIdvIssuers: []);
}

@riverpod
ShareRequirementsMatcher iotaShareRequirementsMatcher(Ref ref) {
  return ShareRequirementsMatcher();
}

/// Unified credential matcher that routes PEX and DCQL requests internally.
@riverpod
CredentialMatcherServiceInterface iotaCredentialMatcherService(Ref ref) {
  return CredentialMatcherService();
}

@riverpod
VerifierMetadataService iotaVerifierMetadataService(Ref ref) {
  return VerifierMetadataService(
    baseUrl: AppConfig.affinidiApiBaseUrl,
  );
}

/// Factory function type for creating [IotaShareResponseServiceInterface]
/// instances.
///
/// Separating creation into a factory provider makes the response service
/// injectable in tests without requiring a vault-specific provider override.
typedef IotaShareResponseServiceFactory = IotaShareResponseServiceInterface
    Function({
  required String vaultId,
  required int accountIndex,
});

@riverpod
IotaShareResponseServiceFactory iotaShareResponseServiceFactory(Ref ref) {
  return ({required String vaultId, required int accountIndex}) =>
      AppIotaShareResponseService(
        vaultId: vaultId,
        accountIndex: accountIndex,
      );
}

@riverpod
IotaShareResponseServiceInterface iotaShareResponseService(
  Ref ref, {
  required String vaultId,
  required int accountIndex,
}) {
  return ref.watch(iotaShareResponseServiceFactoryProvider)(
    vaultId: vaultId,
    accountIndex: accountIndex,
  );
}
