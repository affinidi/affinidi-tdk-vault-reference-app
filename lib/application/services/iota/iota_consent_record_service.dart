import 'package:affinidi_tdk_cryptography/affinidi_tdk_cryptography.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../infrastructure/db/flutter_secure_consent_record_store.dart';
import 'iota_share_flow_service.dart';

part 'iota_consent_record_service.g.dart';

/// Per-vault [ConsentStorage] backed by Flutter secure storage.
///
/// Namespaced by [vaultId] so each vault keeps its own consent history and a
/// backup captures only that vault's records.
@Riverpod(keepAlive: true)
ConsentStorage consentStorage(Ref ref, {required String vaultId}) =>
    FlutterSecureConsentRecordStore.forVault(vaultId);

/// Per-vault [IotaConsentRecordService] used to persist a consent record
/// after a successful share submission.
///
/// Parameters:
/// * [vaultId] - Identifier of the vault whose profile signed the VP.
/// * [accountIndex] - Index of the profile account within the vault. Required
///   to construct the underlying response service used by the consent-record
///   service for the (out-of-scope here) automatic-consent flow.
@riverpod
IotaConsentRecordServiceInterface iotaConsentRecordService(
  Ref ref, {
  required String vaultId,
  required int accountIndex,
}) {
  final responseService = ref.watch(
    iotaShareResponseServiceProvider(
      vaultId: vaultId,
      accountIndex: accountIndex,
    ),
  );
  return IotaConsentRecordService(
    store: ref.watch(consentStorageProvider(vaultId: vaultId)),
    cryptography: CryptographyService(),
    shareResponseService: responseService,
  );
}
