import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../application/services/vault/open_vault_params.dart';

part 'share_credential_page_state.freezed.dart';

/// Lifecycle stage of the share-credential flow.
///
/// Each variant represents a mutually exclusive screen mode; the view
/// switches on this single value rather than juggling several boolean
/// flags. Persistent data (vault registry, profiles, match result, etc.)
/// lives on [ShareCredentialPageState] alongside the stage.
sealed class ShareFlowStage {
  const ShareFlowStage();
}

/// Initial stage while the OID4VP request JWT is being parsed and validated.
class StageValidatingRequest extends ShareFlowStage {
  const StageValidatingRequest();
}

/// The JWT could not be parsed or has expired; the share cannot proceed.
class StageRequestInvalid extends ShareFlowStage {
  const StageRequestInvalid(this.message);
  final String message;
}

/// Request is valid; user must select a vault and enter its passphrase.
/// [error] surfaces a wrong-passphrase message in the input field.
class StageAwaitingPassphrase extends ShareFlowStage {
  const StageAwaitingPassphrase({this.error});
  final String? error;
}

/// Passphrase has been submitted; vault unlock is in progress.
class StageVerifyingPassphrase extends ShareFlowStage {
  const StageVerifyingPassphrase();
}

/// Vault is unlocked; user is choosing (or has just been shown) the
/// profile whose credentials should be matched.
class StageAwaitingProfile extends ShareFlowStage {
  const StageAwaitingProfile();
}

/// Matching profile credentials against the presentation definition.
class StageMatchingCredentials extends ShareFlowStage {
  const StageMatchingCredentials();
}

/// The match service failed; the user can retry by reselecting a profile.
class StageMatchFailed extends ShareFlowStage {
  const StageMatchFailed(this.message);
  final String message;
}

/// Match completed; the user can pick VCs and submit the response.
class StageReadyToShare extends ShareFlowStage {
  const StageReadyToShare();
}

/// User pressed Share/Reject; the response is being sent to the verifier.
class StageSubmitting extends ShareFlowStage {
  const StageSubmitting();
}

/// Submit/reject failed. The view shows a terminal error card.
class StageSubmitFailed extends ShareFlowStage {
  const StageSubmitFailed(this.message);
  final String message;
}

/// Submit/reject completed. The page should pop; if [showShareSuccessToast]
/// is true the parent listener also surfaces a success snackbar.
class StageDismissed extends ShareFlowStage {
  const StageDismissed({required this.showShareSuccessToast});
  final bool showShareSuccessToast;
}

@Freezed(fromJson: false, toJson: false)
class ShareCredentialPageState with _$ShareCredentialPageState {
  factory ShareCredentialPageState({
    required String requestJwt,
    String? clientId,
    @Default(StageValidatingRequest()) ShareFlowStage stage,
    @Default({}) Map<String, OpenVaultParams> vaultRegistry,
    String? selectedVaultId,
    // null = not yet loaded; [] = loaded but vault has no profiles.
    List<Profile>? profiles,
    String? selectedProfileId,
    // Parsed and validated OID4VP request — set after validateRequest().
    Oid4vpShareRequest? shareRequest,
    // Result of matching vault VCs against the PD requirements.
    ClaimedCredentialsResult? matchResult,
    // Resolved verifier identity and branding from VerifierMetadataService.
    VerifierClientMetadata? verifierMetadata,
    // Credential selection.
    @Default(<String>{}) Set<String> selectedCredentialIds,
    @Default(false) bool autoAllowConsent,
    @Default(false) bool isConsentManagementEnabled,
  }) = _ShareCredentialPageState;
}
