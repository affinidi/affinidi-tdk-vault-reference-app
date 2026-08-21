import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../infrastructure/loggers/error_logger/error_logging_handler.dart';
import '../iota/iota_share_flow_service.dart';

/// A validated OID4VP request together with the resolved verifier metadata.
class ValidatedShareRequest {
  const ValidatedShareRequest({required this.request, this.verifierMetadata});

  final Oid4vpShareRequest request;
  final VerifierClientMetadata? verifierMetadata;
}

/// Validates an incoming OID4VP request JWT and resolves the verifier's
/// metadata.
///
/// Missing verifier metadata is non-fatal: a
/// [TdkExceptionType.failedToFetchVerifierMetadata] is logged and the request
/// is returned without metadata so the share flow can still proceed. Any other
/// error propagates to the caller.
class ShareRequestValidationService {
  ShareRequestValidationService({
    required ShareFlowServiceInterface shareFlowService,
    required VerifierMetadataService verifierMetadataService,
  })  : _shareFlowService = shareFlowService,
        _verifierMetadataService = verifierMetadataService;

  final ShareFlowServiceInterface _shareFlowService;
  final VerifierMetadataService _verifierMetadataService;

  Future<ValidatedShareRequest> validate(String requestJwt) async {
    final uri = Uri(queryParameters: {'request': requestJwt});
    final request = await _shareFlowService.validateOid4vpRequest(uri);

    VerifierClientMetadata? verifierMetadata;
    try {
      verifierMetadata = await _verifierMetadataService.fetchVerifierMetadata(
        clientId: request.request.clientId,
        clientMetadata: request.request.clientMetadata,
        clientMetadataUri: request.request.clientMetadataUri,
      );
    } on TdkException catch (e, st) {
      if (e.code != TdkExceptionType.failedToFetchVerifierMetadata.code) {
        rethrow;
      }
      ErrorLoggingHandler.instance.logError(
        e,
        st,
        reason: 'fetchVerifierMetadata failed; continuing without metadata',
      );
    }

    return ValidatedShareRequest(
      request: request,
      verifierMetadata: verifierMetadata,
    );
  }
}

final shareRequestValidationServiceProvider =
    Provider<ShareRequestValidationService>(
  (ref) => ShareRequestValidationService(
    shareFlowService: ref.read(iotaShareFlowServiceProvider),
    verifierMetadataService: ref.read(iotaVerifierMetadataServiceProvider),
  ),
);
