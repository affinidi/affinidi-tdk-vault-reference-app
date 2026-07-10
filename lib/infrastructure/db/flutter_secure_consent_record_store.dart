import 'dart:convert';

import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../exceptions/app_exception.dart';

/// Implementation of [ConsentStorage] backed by Flutter's secure storage.
///
/// Each record is stored as a JSON string keyed by its [IotaConsentRecord.hash],
/// prefixed with [namespace] to avoid collisions with other secure-storage entries.
///
/// This implementation mirrors the `FlutterSecureConsentRecordStore` that will be
/// shipped in a future version of `affinidi_tdk_vault_flutter_utils`.
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
    final all = await _secureStorage.readAll();
    final prefix = '${_namespace}_';
    for (final entry in all.entries) {
      if (!entry.key.startsWith(prefix)) continue;
      try {
        final record = IotaConsentRecord.fromJson(
          jsonDecode(entry.value) as Map<String, dynamic>,
        );
        if (record.requestHash == requestHash) return record;
      } catch (error) {
        throw AppException(
          message: 'Failed to read consent record from secure storage: $error',
          type: AppExceptionType.consentStorageError,
        );
      }
    }
    return null;
  }

  /// Returns all stored consent records across all profiles.
  Future<List<IotaConsentRecord>> listAll() async {
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
      } catch (error) {
        throw AppException(
          message: 'Failed to read consent record from secure storage: $error',
          type: AppExceptionType.consentStorageError,
        );
      }
    }
    return records;
  }

  @override
  Future<List<IotaConsentRecord>> findAllByRequestHash(
      String requestHash) async {
    final all = await _secureStorage.readAll();
    final prefix = '${_namespace}_';
    final records = <IotaConsentRecord>[];
    for (final entry in all.entries) {
      if (!entry.key.startsWith(prefix)) continue;
      try {
        final record = IotaConsentRecord.fromJson(
          jsonDecode(entry.value) as Map<String, dynamic>,
        );
        if (record.requestHash == requestHash) {
          records.add(record);
        }
      } catch (error) {
        throw AppException(
          message: 'Failed to read consent record from secure storage: $error',
          type: AppExceptionType.consentStorageError,
        );
      }
    }
    return records;
  }
}
