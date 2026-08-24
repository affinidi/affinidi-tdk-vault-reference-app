import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../iota/iota_share_flow_service.dart';

/// Loads every credential in a profile's storage and matches it against the
/// OID4VP request's presentation definition (PEX or DCQL).
class CredentialMatchingService {
  CredentialMatchingService({
    required CredentialMatcherServiceInterface matcher,
  }) : _matcher = matcher;

  final CredentialMatcherServiceInterface _matcher;

  Future<MatchedCredentialsResult> match({
    required Oid4vpShareRequest shareRequest,
    required CredentialStorage storage,
  }) async {
    final credentials = await _fetchAllCredentials(storage);
    final allVCs = credentials
        .map((credential) => credential.verifiableCredential)
        .toList();
    return _matcher.match(shareRequest, allVCs);
  }

  /// Walks the pagination cursor until the API reports no more pages, so the
  /// matcher evaluates against the entire credential set rather than one page.
  Future<List<DigitalCredential>> _fetchAllCredentials(
    CredentialStorage storage,
  ) async {
    final all = <DigitalCredential>[];
    String? cursor;
    do {
      final page = await storage.listCredentials(exclusiveStartItemId: cursor);
      all.addAll(page.items);
      cursor = page.lastEvaluatedItemId;
    } while (cursor != null);
    return all;
  }
}

final credentialMatchingServiceProvider = Provider<CredentialMatchingService>(
  (ref) => CredentialMatchingService(
    matcher: ref.read(iotaCredentialMatcherServiceProvider),
  ),
);
