import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdk_reference_app/infrastructure/db/flutter_secure_consent_record_store.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const storage = FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      'iota_consent_record-hash': 'record',
      'iota_consent_other-hash': 'other record',
      'custom_record-hash': 'custom record',
      'vault_seed': 'unrelated data',
    });
  });

  test('deletes only the matching namespaced record and returns true',
      () async {
    final store = FlutterSecureConsentRecordStore(secureStorage: storage);

    expect(await store.deleteByHash('record-hash'), isTrue);
    expect(await storage.readAll(), {
      'iota_consent_other-hash': 'other record',
      'custom_record-hash': 'custom record',
      'vault_seed': 'unrelated data',
    });
    expect(await store.deleteByHash('record-hash'), isFalse);
  });

  test('missing records return false without changing storage', () async {
    final store = FlutterSecureConsentRecordStore(secureStorage: storage);
    final before = await storage.readAll();

    expect(await store.deleteByHash('missing'), isFalse);
    expect(await storage.readAll(), before);
  });

  test('uses the configured namespace', () async {
    final store = FlutterSecureConsentRecordStore(
      namespace: 'custom',
      secureStorage: storage,
    );

    expect(await store.deleteByHash('record-hash'), isTrue);
    expect(await storage.containsKey(key: 'custom_record-hash'), isFalse);
    expect(await storage.containsKey(key: 'iota_consent_record-hash'), isTrue);
  });

  test('propagates storage deletion failures', () async {
    final failingStorage = _MockSecureStorage();
    final failure = StateError('Storage unavailable');
    when(() => failingStorage.containsKey(key: 'iota_consent_record-hash'))
        .thenAnswer((_) async => true);
    when(() => failingStorage.delete(key: 'iota_consent_record-hash'))
        .thenAnswer((_) async => throw failure);
    final store =
        FlutterSecureConsentRecordStore(secureStorage: failingStorage);

    await expectLater(
        store.deleteByHash('record-hash'), throwsA(same(failure)));
  });
}
