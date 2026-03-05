import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import 'dart:async';
import 'package:affinidi_tdk_vdsp/affinidi_tdk_vdsp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ssi/ssi.dart';
import 'package:uuid/uuid.dart';

import '../../../application/services/profile/profile_service.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../widgets/loading_status/async_loading_controller.dart';
import 'profiles_page_state.dart';

part 'profiles_page_controller.g.dart';

@riverpod
class ProfilesPageController extends _$ProfilesPageController {
  ProfilesPageController() : super();

  final loadingController = AsyncLoadingController.provider(
    'profilesPageLoadingController',
  );

  final StreamController<VdspQueryDataMessage> _vdspRequestController =
      StreamController<VdspQueryDataMessage>.broadcast();

  /// Stream of incoming VDSP request messages. UI can subscribe to this
  /// broadcast stream to prompt the user and handle the VDSP flow.
  Stream<VdspQueryDataMessage> get vdspRequests =>
      _vdspRequestController.stream;

  bool _listening = false;

  /// Initializes the controller state.
  ///
  /// Automatically loads profiles and listens for profile updates from
  /// [profileServiceProvider].
  ///
  /// Returns the initial [ProfilesPageState].
  @override
  ProfilesPageState build() {
    _loadProfiles();

    ref.listen(
      profileServiceProvider.select((state) => state.profiles),
      (previous, next) {
        Future.microtask(() {
          state = state.copyWith(profiles: next);
        });
      },
      fireImmediately: true,
    );

    _registerDispose();

    return ProfilesPageState();
  }

  void _registerDispose() {
    ref.onDispose(() {
      if (!_vdspRequestController.isClosed) {
        _vdspRequestController.close();
      }
      stopVdspListener();
    });
  }

  /// Triggers a refresh of profiles by calling [getProfiles] in the profile service.
  Future<void> refreshProfiles() async {
    await ref.read(profileServiceProvider.notifier).getProfiles();
  }

  /// Handles logic for closing the Profiles Page:
  /// - Resets the current vault
  /// - Navigates back to the Vaults page
  void resetCurrentVault() {
    final vaultService = ref.read(vaultServiceProvider.notifier);
    vaultService.resetCurrentVault();
  }

  /// Internal method that loads profiles with a loading indicator.
  void _loadProfiles() {
    Future.microtask(() {
      ref
          .read(loadingController.notifier)
          .start(
            () async =>
                await ref.read(profileServiceProvider.notifier).getProfiles(),
          );
    });
  }

  /// Starts the VDSP Flow by initializing the DIDComm Mediator Client, creating
  /// an AccessListAddMessage to configure the ACL with the verifierDid and finally
  /// sending the ACL configuration via the DIDComm Mediator Client.
  Future<void> allowNewVerifier(String verifierDid) async {
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

  /// Starts listening for VDSP requests and emits incoming messages on the
  /// [vdspRequests] stream. UI should subscribe to [vdspRequests] and handle
  /// user prompts and responses.
  Future<void> startVdspListener() async {
    if (_listening) return;
    _listening = true;

    final vault = ref.read(vaultServiceProvider).currentVault;
    if (vault == null) throw Exception('No current vault configured');

    vault.listenForVdspRequests(
      onDataRequest: (message) async {
        _vdspRequestController.add(message);
      },
      onProblemReport: (message) async {
        _vdspRequestController.addError(message);
        await ConnectionPool.instance.stopConnections();
      },
    );

    await ConnectionPool.instance.startConnections();
  }

  /// Stops the stream listener
  Future<void> stopVdspListener() async {
    if (!_listening) return;
    _listening = false;
    await ConnectionPool.instance.stopConnections();
  }

  /// Filters credentials for the incoming VDSP query using the provided
  /// credential storage. Returns the raw result from the vault.
  Future<dynamic> filterCredentialsForVdsp(
    VdspQueryDataMessage message, {
    required dynamic credentialStorage,
  }) async {
    final vault = ref.read(vaultServiceProvider).currentVault;
    if (vault == null) throw Exception('No current vault configured');
    return await vault.filterCredentialsForVdspQueryDataMessage(
      message,
      credentialStorage: credentialStorage,
    );
  }

  /// Sends a VDSP data response using the vault.
  Future<void> sendVdspDataResponse({
    required VdspQueryDataMessage requestMessage,
    required List<ParsedVerifiableCredential<dynamic>> verifiableCredentials,
    required dynamic profile,
    VerifiableCredentialsDataModel verifiablePresentationDataModel =
        VerifiableCredentialsDataModel.v1,
  }) async {
    final vault = ref.read(vaultServiceProvider).currentVault;
    if (vault == null) throw Exception('No current vault configured');
    await vault.sendVdspDataResponse(
      requestMessage: requestMessage,
      verifiableCredentials: verifiableCredentials,
      profile: profile,
      verifiablePresentationDataModel: verifiablePresentationDataModel,
    );
  }
}
