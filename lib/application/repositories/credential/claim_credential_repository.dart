import 'package:affinidi_tdk_claim_verifiable_credential/oid4vci_claim_verifiable_credential.dart';

abstract class ClaimCredentialRepository {
  Future<OID4VCIClaimContext> getOID4VCIClaimContext(Uri uri);
  Future<VerifiableCredential> claimCredentials({
    required OID4VCIClaimContext claimContext,
  });
}
