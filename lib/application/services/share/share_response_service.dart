import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ssi/ssi.dart';

import '../iota/iota_share_flow_service.dart';

/// Sends the wallet's OID4VP response (a presentation or a rejection) to the
/// verifier.
///
/// The verifier may return a redirect [Uri]; the caller decides how to open it.
class ShareResponseService {
  ShareResponseService({
    required IotaShareResponseServiceFactory responseServiceFactory,
  }) : _responseServiceFactory = responseServiceFactory;

  final IotaShareResponseServiceFactory _responseServiceFactory;

  /// Submits [selectedCredentials] as a Verifiable Presentation.
  Future<Uri?> submitShareRequest({
    required String vaultId,
    required int accountIndex,
    required Oid4vpShareRequest shareRequest,
    required List<ParsedVerifiableCredential<dynamic>> selectedCredentials,
  }) =>
      _responseServiceFactory(vaultId: vaultId, accountIndex: accountIndex)
          .submitShareResponse(
        shareRequest: shareRequest,
        selectedCredentials: selectedCredentials,
        acceptResponseUri: shareRequest.request.acceptResponseUri,
      );

  /// Sends an explicit rejection to the verifier callback URL.
  Future<Uri?> rejectShareRequest({
    required String vaultId,
    required int accountIndex,
    required Oid4vpShareRequest shareRequest,
  }) =>
      _responseServiceFactory(vaultId: vaultId, accountIndex: accountIndex)
          .rejectShareResponse(
        shareRequest: shareRequest,
        rejectResponseUri: shareRequest.request.rejectResponseUri,
      );
}

final shareResponseServiceProvider = Provider<ShareResponseService>(
  (ref) => ShareResponseService(
    responseServiceFactory: ref.read(iotaShareResponseServiceFactoryProvider),
  ),
);
