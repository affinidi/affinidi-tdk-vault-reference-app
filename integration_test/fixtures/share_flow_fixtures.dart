import 'package:affinidi_tdk_cryptography/affinidi_tdk_cryptography.dart';
// ignore: implementation_imports
import 'package:affinidi_tdk_cryptography/src/models/verify_jwt_result.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ssi/ssi.dart';

const shareFlowVaultName = 'Share Flow Vault';
const shareFlowPassphrase = 'sharetest123';

/// A minimal OID4VP request URL. The dialog extracts the [request] query
/// parameter and forwards it to [ShareFlowServiceInterface.validateOid4vpRequest].
const shareFlowUrl =
    'https://vault.affinidi.com/login?request=test.fake.jwt&client_id=did:key:testclient';

const _cannedClientId = 'did:key:testclient';
const _cannedJwt = 'test.fake.jwt';

final Map<String, dynamic> _cannedPayload = {
  'nonce': 'test-nonce-456',
  'state': 'test-state-123',
  'client_id': _cannedClientId,
  'client_id_scheme': 'did',
  'response_uri': 'https://test.local/accept',
  'response_type': 'vp_token',
  'response_mode': 'direct_post',
  'exp': 9999999999,
  'iat': 1700000000,
  'presentation_definition': const {
    'id': 'test-pd-id',
    'input_descriptors': [
      {
        'id': 'test-descriptor-id',
        'constraints': {'fields': []},
      },
    ],
  },
};

/// Builds a canned [Oid4vpShareRequest] by driving the real [ShareFlowService]
/// with a stubbed cryptography service.
///
/// [Oid4vpShareRequest] is a sealed type that cannot be constructed directly,
/// so the request is produced through the public validation entry point.
Future<Oid4vpShareRequest> buildCannedShareRequest() {
  final service = ShareFlowService(
    cryptography: _StubCryptography(_cannedPayload),
  );
  final uri = Uri(queryParameters: {'request': _cannedJwt});
  return service.validateOid4vpRequest(uri);
}

/// Stub cryptography that returns the canned [payload] for any token and treats
/// every JWT as valid and unexpired. Only the two methods used by
/// [ShareFlowService] are implemented.
class _StubCryptography extends Fake implements CryptographyServiceInterface {
  _StubCryptography(this._payload);

  final Map<String, dynamic> _payload;

  @override
  Map<String, dynamic> decodeJwtToken({required String token}) => _payload;

  @override
  VerifyJwtResult verifyJwt({
    required String jwtToken,
    required String didKey,
  }) =>
      VerifyJwtResult(
        isValid: true,
        isExpired: false,
        errorMessage: null,
        jwtPayload: _payload,
      );
}

/// Builds a minimal parseable LD VC Data Model v1 credential.
///
/// The [proof] field is required by [LdVcDm1Suite.tryParse]; its cryptographic
/// content is irrelevant because [parsedCredentialFromVc] never re-verifies it.
///
/// Parameters let callers mint distinct credentials (unique [id]/[type]) so
/// multi-group and multi-credential fixtures don't collapse into one entry.
ParsedVerifiableCredential<dynamic> buildFixtureVc({
  String id = 'urn:test:vc:email:1',
  String type = 'EmailCredential',
  String subjectKey = 'email',
  String subjectValue = 'test@example.com',
}) {
  final vcJson = '''
{
  "@context": ["https://www.w3.org/2018/credentials/v1"],
  "id": "$id",
  "type": ["VerifiableCredential", "$type"],
  "issuer": "did:key:z6MktestIssuer",
  "issuanceDate": "2025-01-01T00:00:00Z",
  "credentialSubject": {
    "id": "did:key:z6MktestHolder",
    "$subjectKey": "$subjectValue"
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

/// A match result with two independent descriptor groups, each satisfied by a
/// single credential. Used to verify both groups are shown and submitted.
ClaimedCredentialsResult buildMultiGroupMatchResult({
  required ParsedVerifiableCredential<dynamic> firstVc,
  required ParsedVerifiableCredential<dynamic> secondVc,
}) =>
    ClaimedCredentialsResult(
      vcsGroups: {
        PDDescriptor(data: const {'id': 'group-email', 'name': 'Email'}):
            VCsGroupByType(matchedVCs: [VcAvailable(vc: firstVc)]),
        PDDescriptor(data: const {'id': 'group-phone', 'name': 'Phone'}):
            VCsGroupByType(matchedVCs: [VcAvailable(vc: secondVc)]),
      },
    );

/// A match result with a single group that requires [minimum] credentials.
/// [vcs] must contain at least [minimum] available credentials for the group
/// to be shareable.
ClaimedCredentialsResult buildMinCountMatchResult({
  required List<ParsedVerifiableCredential<dynamic>> vcs,
  required int minimum,
}) =>
    ClaimedCredentialsResult(
      vcsGroups: {
        PDDescriptor(data: const {'id': 'group-email', 'name': 'Email'}):
            VCsGroupByType(
          minimumVCsCountToShare: minimum,
          matchedVCs: [for (final vc in vcs) VcAvailable(vc: vc)],
        ),
      },
    );
