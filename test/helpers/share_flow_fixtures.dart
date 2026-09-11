import 'package:affinidi_tdk_cryptography/affinidi_tdk_cryptography.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:mocktail/mocktail.dart';

// Duplicated from integration_test/fixtures/share_flow_fixtures.dart so unit
// tests don't depend on the integration_test package. Keep in sync.

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

/// Stub cryptography that returns the canned payload for any token and treats
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
