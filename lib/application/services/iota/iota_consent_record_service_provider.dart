import 'package:affinidi_tdk_cryptography/affinidi_tdk_cryptography.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../infrastructure/providers/consent_record_store_provider.dart';

part 'iota_consent_record_service_provider.g.dart';

/// Provides an [IotaConsentRecordService] wired to the app's secure-storage
/// [ConsentRecordStore].
///
/// Kept alive so the underlying store singleton is shared across the app.
@Riverpod(keepAlive: true)
IotaConsentRecordService iotaConsentRecordService(Ref ref) {
  return IotaConsentRecordService(
    store: ref.watch(consentRecordStoreProvider),
    cryptography: CryptographyService(),
  );
}
