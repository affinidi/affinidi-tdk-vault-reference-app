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
/// The [_NullShareResponseService] stub is intentional: this provider is used
/// only for [IotaConsentRecordService.saveConsentRecord], which never invokes
/// the share response service. Auto-consent submission uses a fresh
/// [IotaConsentRecordService] with a real signer; see
/// [ShareCredentialPageController._tryAutomaticConsentAndSubmit].
@Riverpod(keepAlive: true)
IotaConsentRecordService iotaConsentRecordService(Ref ref) {
  return IotaConsentRecordService(
    store: ref.watch(consentStorageProvider),
    cryptography: CryptographyService(),
    shareResponseService: const _NullShareResponseService(),
  );
}

/// A no-op [IotaShareResponseServiceInterface] used in the singleton provider
/// where auto-consent submission is never performed.
///
/// Throws [UnsupportedError] if accidentally called, so any unintended usage is
/// caught immediately in development.
class _NullShareResponseService implements IotaShareResponseServiceInterface {
  const _NullShareResponseService();

  @override
  Future<Uri?> submitShareResponse({
    required String state,
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
        '_NullShareResponseService.submitShareResponse must never be called. '
        'Use a service built with a real DidSigner for auto-consent submission.',
      );

  @override
  Future<Uri?> rejectShareResponse({required String state}) =>
      throw UnsupportedError(
        '_NullShareResponseService.rejectShareResponse must never be called.',
      );
}
