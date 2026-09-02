import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';

import '../../ports/share_vault_session.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import 'consent_service.dart';
import 'credential_matching_service.dart';
import 'share_request_validation_service.dart';
import 'share_submission_service.dart';

/// Outcome of [ShareCredentialFlowService.matchCredentials].
sealed class ShareMatchOutcome {
  const ShareMatchOutcome();
}

/// Matching completed; the user can pick VCs and submit.
class MatchReadyToShare extends ShareMatchOutcome {
  const MatchReadyToShare(this.matchResult);
  final MatchedCredentialsResult matchResult;
}

/// A stored consent record already covered this request; the VP was
/// submitted automatically and the flow should dismiss without user input.
class MatchAutoConsented extends ShareMatchOutcome {
  const MatchAutoConsented(this.dismissal);
  final ShareDismissalOutcome dismissal;
}

/// Result of submitting or rejecting a share request.
class ShareDismissalOutcome {
  const ShareDismissalOutcome({required this.redirectUri});

  final Uri? redirectUri;
}

/// Orchestrates the share-credential wizard's business steps: unlocking a
/// vault and loading its profiles, validating and matching an OID4VP
/// request, and submitting or rejecting it.
///
/// Composes the existing share/vault/profile services so the page controller
/// only has to call one step at a time and translate the result into UI
/// state, instead of sequencing these services itself.
class ShareCredentialFlowService {
  ShareCredentialFlowService({
    required ShareVaultSession vaultSession,
    required ShareRequestValidationService validationService,
    required CredentialMatchingService matchingService,
    required ConsentService consentService,
    required ShareSubmissionService submissionService,
  })  : _vaultSession = vaultSession,
        _validationService = validationService,
        _matchingService = matchingService,
        _consentService = consentService,
        _submissionService = submissionService;

  final ShareVaultSession _vaultSession;
  final ShareRequestValidationService _validationService;
  final CredentialMatchingService _matchingService;
  final ConsentService _consentService;
  final ShareSubmissionService _submissionService;

  bool isVaultOpen(String vaultId) => _vaultSession.isOpen(vaultId);

  /// Unlocks [vaultId] with [password].
  Future<void> unlockVault({
    required String vaultId,
    required String password,
  }) =>
      _vaultSession.unlock(vaultId: vaultId, password: password);

  /// Loads profiles for the currently open vault.
  Future<List<Profile>> loadProfilesForOpenVault() async {
    if (!_vaultSession.hasOpenVault) return [];
    return _vaultSession.loadProfiles();
  }

  /// Validates [requestJwt] and resolves the verifier metadata.
  Future<ValidatedShareRequest> validateRequest(String requestJwt) =>
      _validationService.validate(requestJwt);

  /// Matches [profileId]'s credentials against [shareRequest] and checks for
  /// a stored consent that auto-approves the share.
  ///
  /// Throws [AppException] (type [AppExceptionType.missingProfile]) if
  /// [profileId] isn't in the already-loaded profile list.
  Future<ShareMatchOutcome> matchCredentials({
    required String vaultId,
    required String profileId,
    required Oid4vpShareRequest shareRequest,
    required VerifierClientMetadata verifierMetadata,
  }) async {
    if (!_vaultSession.isOpen(vaultId)) {
      throw AppException(
        message: 'Vault is not open.',
        type: AppExceptionType.vaultNotInitialized,
      );
    }

    final profile = _resolveProfile(profileId);
    final storage = profile.defaultCredentialStorage;
    if (storage == null) {
      return const MatchReadyToShare(ClaimedCredentialsResult(vcsGroups: {}));
    }

    final matchResult = await _matchingService.match(
      shareRequest: shareRequest,
      storage: storage,
    );

    final consentResult = await _consentService.tryAutomaticConsent(
      vaultId: vaultId,
      accountIndex: profile.accountIndex,
      shareRequest: shareRequest,
      matchResult: matchResult,
      verifierMetadata: verifierMetadata,
    );

    switch (consentResult) {
      case AutoConsentApproved(:final redirectUri):
        return MatchAutoConsented(_resolveDismissal(redirectUri));
      case AutoConsentDeclined():
        return MatchReadyToShare(matchResult);
    }
  }

  /// Submits the selected credentials as a Verifiable Presentation.
  ///
  /// Throws [AppException] (type [AppExceptionType.missingVerifiableCredentials])
  /// if a group doesn't have enough selected credentials.
  Future<ShareDismissalOutcome> submit({
    required String vaultId,
    required String profileId,
    required Oid4vpShareRequest shareRequest,
    required MatchedCredentialsResult matchResult,
    required Set<String> selectedCredentialIds,
    required VerifierClientMetadata verifierMetadata,
    required bool autoAllowConsent,
    required bool isConsentManagementEnabled,
  }) async {
    final profile = _resolveProfile(profileId);

    final selection = _submissionService.selectCredentials(
      matchResult: matchResult,
      selectedIds: selectedCredentialIds,
    );
    if (selection is InsufficientCredentials) {
      throw AppException(
        message: 'Not enough matching credentials for one or more groups.',
        type: AppExceptionType.missingVerifiableCredentials,
      );
    }

    final redirectUri = await _submissionService.submit(
      vaultId: vaultId,
      profile: profile,
      shareRequest: shareRequest,
      credentials: (selection as CredentialsSelected).credentials,
      verifierMetadata: verifierMetadata,
      isAutoShareEnabled: autoAllowConsent,
      isConsentManagementEnabled: isConsentManagementEnabled,
    );

    return ShareDismissalOutcome(redirectUri: redirectUri);
  }

  /// Sends an explicit rejection to the verifier.
  ///
  /// Throws [AppException] (type [AppExceptionType.redirectLaunchFailed]) if
  /// the verifier's redirect URI fails to launch.
  Future<ShareDismissalOutcome> reject({
    required String vaultId,
    required String profileId,
    required Oid4vpShareRequest shareRequest,
  }) async {
    final profile = _resolveProfile(profileId);
    final redirectUri = await _submissionService.reject(
      vaultId: vaultId,
      profile: profile,
      shareRequest: shareRequest,
    );

    return ShareDismissalOutcome(redirectUri: redirectUri);
  }

  Profile _resolveProfile(String profileId) {
    final profiles = _vaultSession.profiles;
    if (profiles.isEmpty) {
      throw AppException(
        message: 'Profiles are not loaded.',
        type: AppExceptionType.missingProfile,
      );
    }
    return profiles.firstWhere(
      (profile) => profile.id == profileId,
      orElse: () => throw AppException(
        message: 'Selected profile was not found in current vault.',
        type: AppExceptionType.missingProfile,
      ),
    );
  }

  ShareDismissalOutcome _resolveDismissal(Uri? redirectUri) =>
      ShareDismissalOutcome(redirectUri: redirectUri);
}
