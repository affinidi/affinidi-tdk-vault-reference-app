import 'dart:async';

import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import 'package:affinidi_tdk_vdsp/affinidi_tdk_vdsp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ssi/ssi.dart';
import 'package:uuid/uuid.dart';

import '../../../application/services/vault/vault_service.dart';
part 'vault_settings_page_controller.g.dart';

@riverpod
class VaultSettingsPageController extends _$VaultSettingsPageController {
  VaultSettingsPageController() : super();

  // final StreamController<VdspQueryDataMessage> _vdspRequestController =
  //     StreamController<VdspQueryDataMessage>.broadcast();

  /// Stream of incoming VDSP request messages. UI can subscribe to this
  /// broadcast stream to prompt the user and handle the VDSP flow.
  // Stream<VdspQueryDataMessage> get vdspRequests =>
  //     _vdspRequestController.stream;

  // bool _listening = false;

  @override
  bool build() {
    // _registerDispose();
    return false;
  }

  /// Whitelists the given verifier DID by sending an ACL message to the mediator.
  Future<void> whitelistVerifierDid(String verifierDid) async {
    final vault = ref.read(vaultServiceProvider).currentVault;

    final ownDidDocument = await vault!.didManager.getDidDocument();
    final didManager = vault.didManager;

    final bridgeIotaDidDocument = await UniversalDIDResolver.defaultResolver
        .resolveDid(vault.bridgeIotaDid);

    final mediatorService = bridgeIotaDidDocument.service
        .where((service) => service.type.toString() == 'DIDCommMessaging')
        .firstOrNull;

    if (mediatorService == null) {
      throw Exception(
        'No DIDCommMessaging service found in the bridge IOTA DID Document',
      );
    }

    final mediatorDid = mediatorService.id.split('#').first;

    final mediatorDidDocument = await UniversalDIDResolver.defaultResolver
        .resolveDid(mediatorDid);

    final mediatorClient = await DidcommMediatorClient.init(
      mediatorDidDocument: mediatorDidDocument,
      didManager: didManager,
      authorizationProvider: await AffinidiAuthorizationProvider.init(
        mediatorDidDocument: mediatorDidDocument,
        didManager: didManager,
      ),
      clientOptions: const AffinidiClientOptions(),
    );

    final accessListAddMessage = AccessListAddMessage(
      id: const Uuid().v4(),
      from: ownDidDocument.id,
      to: [mediatorClient.mediatorDidDocument.id],
      theirDids: [verifierDid],
    );

    await mediatorClient.sendAclManagementMessage(accessListAddMessage);
  }

  // void _registerDispose() {
  //   ref.onDispose(() {
  //     if (!_vdspRequestController.isClosed) {
  //       _vdspRequestController.close();
  //     }
  //     stopVdspListener();
  //   });
  // }

  /// Starts listening for VDSP requests and emits incoming messages on the
  /// [vdspRequests] stream. UI should subscribe to [vdspRequests] and handle
  /// user prompts and responses.
  Future<void> startVdspListener() async {
    await ref.read(vaultServiceProvider.notifier).startVdspListener();

    // if (_listening) return;
    // _listening = true;

    // final vault = ref.read(vaultServiceProvider).currentVault;
    // if (vault == null) throw Exception('No current vault configured');

    // prettyPrint('Starting VDSP listener...');
    // vault.listenForVdspRequests(
    //   onDataRequest: (message) async {
    //     _vdspRequestController.add(message);
    //   },
    //   onProblemReport: (message) async {
    //     _vdspRequestController.addError(message);
    //     await ConnectionPool.instance.stopConnections();
    //   },
    // );

    // await ConnectionPool.instance.startConnections();

    // prettyPrint('Connection Pool Started!');
  }

  /// Stops the stream listener
  Future<void> stopVdspListener() async {
    await ref.read(vaultServiceProvider.notifier).stopVdspListener();
    // if (!_listening) return;
    // _listening = false;
    // await ConnectionPool.instance.stopConnections();
  }
}
