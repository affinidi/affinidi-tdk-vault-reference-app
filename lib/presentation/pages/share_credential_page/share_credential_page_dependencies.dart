import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/services/profile/profile_service.dart';
import '../../../application/services/share/consent_service.dart';
import '../../../application/services/share/credential_matching_service.dart';
import '../../../application/services/share/share_credential_flow_service.dart';
import '../../../application/services/share/share_request_validation_service.dart';
import '../../../application/services/share/share_submission_service.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../infrastructure/external_link/external_redirect_service.dart';

final shareCredentialFlowServiceProvider = Provider<ShareCredentialFlowService>(
  (ref) => ShareCredentialFlowService(
    vaultService: ref.read(vaultServiceProvider.notifier),
    vaultState: () => ref.read(vaultServiceProvider),
    loadProfiles: () => ref.read(profileServiceProvider.notifier).getProfiles(),
    currentProfiles: () =>
        ref.read(profileServiceProvider).profiles ?? const [],
    validationService: ref.read(shareRequestValidationServiceProvider),
    matchingService: ref.read(credentialMatchingServiceProvider),
    consentService: ref.read(consentServiceProvider),
    submissionService: ref.read(shareSubmissionServiceProvider),
    redirectLauncher: ref.read(externalRedirectServiceProvider),
  ),
);