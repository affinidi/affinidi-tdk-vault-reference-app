import 'package:affinidi_tdk_claim_verifiable_credential/oid4vci_claim_verifiable_credential.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'claim_credentials_page_state.freezed.dart';

enum CredentialOfferFetchStatus {
  initial,
  loading,
  success,
  error,
}

@Freezed(fromJson: false, toJson: false)
class ClaimCredentialsPageState with _$ClaimCredentialsPageState {
  ClaimCredentialsPageState._();

  factory ClaimCredentialsPageState({
    OID4VCIClaimContext? claimContext,
    VerifiableCredential? verifiableCredential,
    Uri? offerUri,
    required String profileId,
    @Default(CredentialOfferFetchStatus.initial)
    CredentialOfferFetchStatus fetchStatus,
    String? fetchErrorMessage,
  }) = _ClaimCredentialsPageState;

  OID4VCICredentialOffer? get credentialOffer => claimContext?.credentialOffer;
}
