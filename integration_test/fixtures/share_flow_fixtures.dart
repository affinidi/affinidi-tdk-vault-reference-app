import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:ssi/ssi.dart';

const shareFlowVaultName = 'Share Flow Vault';
const shareFlowPassphrase = 'sharetest123';

/// A minimal OID4VP request URL. The dialog extracts the [request] query
/// parameter and forwards it to [ShareFlowServiceInterface.validateOid4vpRequest].
const shareFlowUrl =
    'https://vault.affinidi.com/login?request=test.fake.jwt&client_id=did:key:testclient';

Oid4vpShareRequest buildCannedShareRequest() => Oid4vpShareRequest(
      request: const IotaRequest(
        responseType: 'vp_token',
        responseMode: 'direct_post',
        acceptResponseUri: 'https://test.local/accept',
        rejectResponseUri: 'https://test.local/reject',
        state: 'test-state-123',
        nonce: 'test-nonce-456',
        clientId: 'did:key:testclient',
      ),
      presentationDefinition: const {
        'id': 'test-pd-id',
        'input_descriptors': [
          {
            'id': 'test-descriptor-id',
            'constraints': {'fields': []},
          },
        ],
      },
      jwtAssertion: 'test.fake.jwt',
    );

/// Builds a minimal parseable LD VC Data Model v1 credential.
///
/// The [proof] field is required by [LdVcDm1Suite.tryParse]; its cryptographic
/// content is irrelevant because [parsedCredentialFromVc] never re-verifies it.
ParsedVerifiableCredential<dynamic> buildFixtureVc() {
  const vcJson = '''
{
  "@context": ["https://www.w3.org/2018/credentials/v1"],
  "id": "urn:test:vc:email:1",
  "type": ["VerifiableCredential", "EmailCredential"],
  "issuer": "did:key:z6MktestIssuer",
  "issuanceDate": "2025-01-01T00:00:00Z",
  "credentialSubject": {
    "id": "did:key:z6MktestHolder",
    "email": "test@example.com"
  },
  "proof": {
    "type": "Ed25519Signature2018",
    "created": "2025-01-01T00:00:00Z",
    "proofPurpose": "assertionMethod",
    "verificationMethod": "did:key:z6MktestIssuer#key-1",
    "jws": "eyJhbGciOiJFZERTQSIsImI2NCI6ZmFsc2UsImNyaXQiOlsiYjY0Il19..test"
  }
}
''';
  final vc = LdVcDm1Suite().tryParse(vcJson);
  assert(vc != null, 'Fixture VC must parse successfully');
  return vc!;
}

ClaimedCredentialsResult buildMatchResult(
  ParsedVerifiableCredential<dynamic> vc,
) =>
    ClaimedCredentialsResult(
      vcsGroups: {
        PDDescriptor(
          data: const {'id': 'test-descriptor-id', 'name': 'Email'},
        ): VCsGroupByType(
          matchedVCs: [VcAvailable(vc: vc)],
        ),
      },
    );
