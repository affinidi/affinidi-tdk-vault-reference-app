import 'package:affinidi_tdk_cryptography/affinidi_tdk_cryptography.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ssi/ssi.dart' show ParsedVerifiableCredential;

import '../../../infrastructure/providers/consent_storage_provider.dart';

part 'iota_consent_record_service_provider.g.dart';

/// Provides an [IotaConsentRecordService] wired to the app's secure-storage
/// [ConsentStorage].
///
/// Kept alive so the underlying store singleton is shared across the app.
@Riverpod(keepAlive: true)
IotaConsentRecordService iotaConsentRecordService(Ref ref) {
  return IotaConsentRecordService(
    store: ref.watch(consentStorageProvider),
    cryptography: CryptographyService(),
    shareResponseService: _NeverCalledShareResponseService(),
  );
}

/// Stub [IotaShareResponseServiceInterface] used only so
/// [IotaConsentRecordService] can be instantiated in a global provider.
/// This provider is used exclusively for [IotaConsentRecordService.saveConsentRecord],
/// which does not call the response service.
class _NeverCalledShareResponseService
    implements IotaShareResponseServiceInterface {
  @override
  Future<Uri?> submitShareResponse({required String state,
    required String nonce,
    required String clientId,
    required String definitionId,
    required List<
        ({
          PDDescriptor descriptor,
          ParsedVerifiableCredential<dynamic> credential,
        })>
        selectedCredentials,
  }) =>
      throw UnsupportedError(
          '_NeverCalledShareResponseService.submitShareResponse should never be called');

  @override
  Future<Uri?> rejectShareResponse({required String state}) =>
      throw UnsupportedError(
          '_NeverCalledShareResponseService.rejectShareResponse should never be called');
}
