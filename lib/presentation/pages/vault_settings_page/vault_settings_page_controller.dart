import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ssi/ssi.dart';
import 'package:uuid/uuid.dart';

import '../../../application/services/vault/vault_service.dart';
part 'vault_settings_page_controller.g.dart';

@riverpod
class VaultSettingsPageController extends _$VaultSettingsPageController {
  VaultSettingsPageController() : super();

  @override
  bool build() {
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
}
