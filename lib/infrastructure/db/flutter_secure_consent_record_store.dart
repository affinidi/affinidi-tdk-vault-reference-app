import 'dart:convert';

import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Implementation of [ConsentStorage] backed by Flutter's secure storage.
///
/// Each record is stored as a JSON string keyed by its [IotaConsentRecord.hash],
/// prefixed with [namespace] to avoid collisions with other secure-storage entries.
///
/// Vendored locally until an equivalent store ships in
/// `affinidi_tdk_vault_flutter_utils`; replace this with the upstream import
/// once it exposes one.
class FlutterSecureConsentRecordStore implements ConsentStorage {
  /// Creates a [FlutterSecureConsentRecordStore].
  ///
  /// Parameters:
  /// * [namespace] - Prefix applied to every storage key. Defaults to `iota_consent`.
  /// * [secureStorage] - Optional [FlutterSecureStorage] instance for testing.
  FlutterSecureConsentRecordStore({
    String namespace = 'iota_consent',
    FlutterSecureStorage? secureStorage,
  })  : _namespace = namespace,
        _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.unlocked_this_device,
              ),
            );

  final String _namespace;
  final FlutterSecureStorage _secureStorage;

  String _key(String hash) => '${_namespace}_$hash';

  @override
  Future<void> saveOrUpdate(IotaConsentRecord record) async {
    await _secureStorage.write(
      key: _key(record.hash),
      value: jsonEncode(record.toJson()),
    );
  }

  @override
  Future<IotaConsentRecord?> findByRequestHash(String requestHash) async {
    final matches = await findAllByRequestHash(requestHash);
    if (matches.isEmpty) return null;
    matches.sort((a, b) => b.sharedAt.compareTo(a.sharedAt));
    return matches.first;
  }

  /// Returns all stored consent records across all profiles.
  Future<List<IotaConsentRecord>> listAll() => _readAll();

  @override
  Future<List<IotaConsentRecord>> findAllByRequestHash(
    String requestHash,
  ) async {
    final all = await _readAll();
    return [
      for (final record in all)
        if (record.requestHash == requestHash) record,
    ];
  }

  @override
  Future<bool> deleteByHash(String hash) async {
    final key = _key(hash);
    if (!await _secureStorage.containsKey(key: key)) return false;
    await _secureStorage.delete(key: key);
    return true;
  }

  Future<List<IotaConsentRecord>> _readAll() async {
    final all = await _secureStorage.readAll();
    final prefix = '${_namespace}_';
    final records = <IotaConsentRecord>[];
    for (final entry in all.entries) {
      if (!entry.key.startsWith(prefix)) continue;
      try {
        records.add(
          IotaConsentRecord.fromJson(
            jsonDecode(entry.value) as Map<String, dynamic>,
          ),
        );
      } catch (_) {
        // Skip malformed/legacy entries so one bad record doesn't break the
        // entire consent history and auto-consent lookups.
        continue;
      }
    }
    return records;
  }
}
