import 'package:affinidi_tdk_claim_verifiable_credential/oid4vci_claim_verifiable_credential.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'claim_credential_service_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class ClaimCredentialServiceState with _$ClaimCredentialServiceState {
  factory ClaimCredentialServiceState({
    OID4VCIClaimContext? claimContext,
    VerifiableCredential? verifiableCredential,
  }) = _ClaimCredentialServiceState;
}
