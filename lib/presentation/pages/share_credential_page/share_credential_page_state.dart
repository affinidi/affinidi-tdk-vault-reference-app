import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../application/services/vault/open_vault_params.dart';

part 'share_credential_page_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class ShareCredentialPageState with _$ShareCredentialPageState {
  factory ShareCredentialPageState({
    required String requestJwt,
    String? clientId,
    @Default({}) Map<String, OpenVaultParams> vaultRegistry,
    String? selectedVaultId,
    @Default(false) bool isVerifyingPassphrase,
    String? passphraseError,
    // null = not yet loaded; [] = loaded but vault has no profiles
    List<Profile>? profiles,
    String? selectedProfileId,
    // The parsed and validated OID4VP request — set after validateRequest().
    Oid4vpShareRequest? shareRequest,
    // Matching state — set while matchCredentials() is running.
    @Default(false) bool isMatchingCredentials,
    // The result of matching vault VCs against the PD requirements.
    ClaimedCredentialsResult? matchResult,
    // Error from matchCredentials() — set when the service call fails.
    String? matchError,
    // Top-level error from validateRequest (e.g. expired JWT).
    String? requestError,
    // Resolved verifier identity and branding from VerifierMetadataService.
    VerifierClientMetadata? verifierMetadata,
    // Credential selection and submission state.
    @Default(<String>{}) Set<String> selectedCredentialIds,
    @Default(false) bool isSubmitting,
    String? submitError,
  }) = _ShareCredentialPageState;
}
