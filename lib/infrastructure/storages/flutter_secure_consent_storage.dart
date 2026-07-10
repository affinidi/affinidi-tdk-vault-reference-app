import 'dart:convert';

import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// [ConsentStorage] backed by [FlutterSecureStorage].
///
/// Mirrors the upstream `FlutterSecureConsentStorage` from
/// `affinidi_tdk_vault_flutter_utils`. Vendored locally because the published
/// version of that package available to the reference app does not yet expose
/// this class — replace this with the upstream import once it does.
class FlutterSecureConsentStorage implements ConsentStorage {
  /// Creates a [FlutterSecureConsentStorage].
  ///
  /// Parameters:
  /// * [namespace] - Prefix applied to every storage key. Defaults to
  ///   `iota_consent`.
  /// * [secureStorage] - Optional [FlutterSecureStorage] instance, primarily
  ///   for testing.
  FlutterSecureConsentStorage({
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
  Future<void> saveOrUpdate(IotaConsentRecord record) {
    return _secureStorage.write(
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

  @override
  Future<List<IotaConsentRecord>> findAllByRequestHash(
      String requestHash) async {
    return [
      for (final record in await _readAll())
        if (record.requestHash == requestHash) record,
    ];
  }

  Future<List<IotaConsentRecord>> _readAll() async {
    final entries = await _secureStorage.readAll();
    final prefix = '${_namespace}_';
    return [
      for (final entry in entries.entries)
        if (entry.key.startsWith(prefix))
          IotaConsentRecord.fromJson(
            jsonDecode(entry.value) as Map<String, dynamic>,
          ),
    ];
  }
}
