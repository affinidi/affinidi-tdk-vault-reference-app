import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart'
    show ProfileRepository;
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdk_reference_app/application/services/vault/open_vault_params.dart';
import 'package:tdk_reference_app/application/services/vault/vault_service.dart';
import 'package:tdk_reference_app/application/services/vaults_manager/vaults_manager_service.dart';
import 'package:tdk_reference_app/infrastructure/exceptions/app_exception.dart';
import 'package:tdk_reference_app/presentation/pages/vaults_page/vaults_page_controller.dart';

class _FailingVaultsManager extends VaultsManagerService {
  String? attemptedVaultId;

  @override
  Future<void> addVault(OpenVaultParams vault) async {
    attemptedVaultId = vault.vaultId;
    throw StateError('Registry write failed');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const storage = FlutterSecureStorage();
  const pathChannel = MethodChannel('plugins.flutter.io/path_provider');
  final seed = base64Encode(List<int>.filled(32, 1));
  late Directory directory;
  late ProviderContainer container;
  late VaultService service;
  late int directoryRequests;
  late void Function(String) originalDebugPrint;
  late List<String> driftWarnings;

  Map<String, dynamic> entry(String vaultId) => {
        'vaultId': vaultId,
        'vaultName': vaultId,
        'password': 'test-password',
        'base64Seed': seed,
      };

  Future<void> registerVaults(List<String> vaultIds) async {
    await storage.write(
      key: 'vault_registry_map',
      value:
          jsonEncode({for (final vaultId in vaultIds) vaultId: entry(vaultId)}),
    );
    for (final vaultId in vaultIds) {
      await storage.write(key: '${vaultId}_seed', value: seed);
    }
    await container.read(vaultsManagerServiceProvider.notifier).loadVaults();
  }

  Future<ProfileRepository> openVault(String vaultId) async {
    await service.open(vaultId: vaultId, password: 'test-password');
    final vault = container.read(vaultServiceProvider).currentVault!;
    final repository = vault.profileRepositories['${vaultId}_edge_repository']!;
    await repository.listProfiles();
    return repository;
  }

  File databaseFile(String vaultId, [String suffix = '']) => File(
      '${directory.path}/edge_profiles_${vaultId.replaceAll('-', '_')}_edge_repository.db$suffix');

  setUp(() async {
    driftWarnings = [];
    originalDebugPrint = driftRuntimeOptions.debugPrint;
    driftRuntimeOptions.debugPrint = (message) {
      if (message.contains('WARNING (drift)')) driftWarnings.add(message);
      originalDebugPrint(message);
    };
    FlutterSecureStorage.setMockInitialValues({});
    directory = await Directory.systemTemp.createTemp('vault_service_test_');
    directoryRequests = 0;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathChannel, (call) async {
      expect(call.method, 'getApplicationDocumentsDirectory');
      directoryRequests++;
      return directory.path;
    });
    container = ProviderContainer();
    service = container.read(vaultServiceProvider.notifier);
  });

  tearDown(() async {
    await service.resetCurrentVault();
    container.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathChannel, null);
    await directory.delete(recursive: true);
    driftRuntimeOptions.debugPrint = originalDebugPrint;
    expect(driftWarnings, isEmpty);
  });

  test('listing registry entries does not construct vaults or rewrite seeds',
      () async {
    await storage.write(
      key: 'vault_registry_map',
      value: jsonEncode(
          {'vault-1': entry('vault-1'), 'vault-2': entry('vault-2')}),
    );
    final loaded = Completer<void>();
    final subscription =
        container.listen(vaultsPageControllerProvider, (previous, next) {
      if (previous?.isLoading == true && !next.isLoading) loaded.complete();
    });
    await loaded.future;

    expect(container.read(vaultsManagerServiceProvider).vaultRegistry,
        hasLength(2));
    expect(container.read(vaultServiceProvider).currentVault, isNull);
    expect(directoryRequests, 0);
    expect(await storage.readAll(), hasLength(1));
    subscription.close();
  });

  test('invalid passwords do not open a database', () async {
    await registerVaults(['vault-1']);
    await expectLater(
      service.open(vaultId: 'vault-1', password: 'wrong'),
      throwsA(isA<AppException>().having(
          (error) => error.type, 'type', AppExceptionType.invalidPassword)),
    );
    expect(directoryRequests, 0);
  });

  test('concurrent opens reuse one vault and database', () async {
    await registerVaults(['vault-1']);
    final repositories = await Future.wait([
      openVault('vault-1'),
      openVault('vault-1'),
    ]);
    expect(identical(repositories.first, repositories.last), isTrue);
    expect(directoryRequests, 1);
    expect(await databaseFile('vault-1').exists(), isTrue);
  });

  test('reset closes before an immediately following open', () async {
    await registerVaults(['vault-1']);
    final previous = await openVault('vault-1');
    final resetting = service.resetCurrentVault();
    final opening = service.open(vaultId: 'vault-1', password: 'test-password');
    await Future.wait([resetting, opening]);

    final reopened = await openVault('vault-1');
    expect(identical(previous, reopened), isFalse);
    expect(directoryRequests, 2);
    await expectLater(previous.listProfiles(), throwsA(isA<StateError>()));
  });

  test('switching vaults closes the previous database', () async {
    await registerVaults(['vault-1', 'vault-2']);
    final previous = await openVault('vault-1');
    await openVault('vault-2');
    expect(container.read(vaultServiceProvider).currentVaultId, 'vault-2');
    await expectLater(previous.listProfiles(), throwsA(isA<StateError>()));
  });

  test('deleting an unopened vault removes its files and preserves the session',
      () async {
    await registerVaults(['vault-1', 'vault-2']);
    final current = await openVault('vault-1');
    for (final suffix in ['', '-wal', '-shm', '-journal']) {
      await databaseFile('vault-2', suffix).writeAsString('deleted vault data');
    }

    await service.deleteVault('vault-2');

    for (final suffix in ['', '-wal', '-shm', '-journal']) {
      expect(await databaseFile('vault-2', suffix).exists(), isFalse);
    }
    expect(container.read(vaultsManagerServiceProvider).vaultRegistry.keys,
        ['vault-1']);
    expect(container.read(vaultServiceProvider).currentVaultId, 'vault-1');
    await current.listProfiles();
  });

  test('deleting the current vault closes and removes its database', () async {
    await registerVaults(['vault-1']);
    final repository = await openVault('vault-1');
    await service.deleteVault('vault-1');
    expect(container.read(vaultServiceProvider).currentVault, isNull);
    expect(container.read(vaultServiceProvider).currentVaultId, isNull);
    expect(await databaseFile('vault-1').exists(), isFalse);
    await expectLater(repository.listProfiles(), throwsA(isA<StateError>()));
  });

  test('failed creation evicts its database so the same id can be reopened',
      () async {
    container.dispose();
    final manager = _FailingVaultsManager();
    container = ProviderContainer(overrides: [
      vaultsManagerServiceProvider.overrideWith(() => manager),
    ]);
    service = container.read(vaultServiceProvider.notifier);
    await expectLater(
      service.create(vaultName: 'Test vault', password: 'test-password'),
      throwsA(isA<StateError>()),
    );
    final vaultId = manager.attemptedVaultId!;
    expect(container.read(vaultServiceProvider).currentVault, isNull);
    expect(directoryRequests, 1);

    await registerVaults([vaultId]);
    await openVault(vaultId);
    expect(directoryRequests, 2);
  });
}
