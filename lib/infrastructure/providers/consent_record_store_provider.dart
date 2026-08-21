import 'package:affinidi_tdk_vault_flutter_utils/affinidi_tdk_vault_flutter_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consent_record_store_provider.g.dart';

/// Provides a per-vault [FlutterSecureConsentStorage] backed by Flutter
/// secure storage.
///
/// Keeps alive for the lifetime of the app — consent records are written
/// after every successful share and must not be discarded on dispose.
///
/// Namespaced by [vaultId] so each vault reads and writes only its own records.
/// Returns the concrete type so callers can use extended API (e.g. [listAll]).
@Riverpod(keepAlive: true)
FlutterSecureConsentStorage consentRecordStore(
  Ref ref, {
  required String vaultId,
}) {
  return FlutterSecureConsentStorage(namespace: 'iota_consent_$vaultId');
}
