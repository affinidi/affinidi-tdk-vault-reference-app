import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../db/flutter_secure_consent_record_store.dart';

part 'consent_record_store_provider.g.dart';

/// Provides a [FlutterSecureConsentRecordStore] backed by Flutter secure storage.
///
/// Keeps alive for the lifetime of the app — consent records are written
/// after every successful share and must not be discarded on dispose.
///
/// Returns the concrete type so callers can use extended API (e.g. [listAll]).
@Riverpod(keepAlive: true)
FlutterSecureConsentRecordStore consentRecordStore(Ref ref) {
  return FlutterSecureConsentRecordStore();
}
