// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart'
    hide CredentialFormat;
import 'package:didcomm/didcomm.dart' hide AccessListAddMessage;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ssi/ssi.dart';
import 'package:uuid/uuid.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/profiles/profiles_route_constants.dart';
import '../../../navigation/flows/vdsp_share_credentials/vdsp_share_credentials_constants.dart';
import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../shared_page/shared_page_controller.dart';
import '../shared_page/widget/shared_profile_card.dart';

void prettyPrint(String name, {Object? object}) {
  if (object == null) {
    print(name);
  } else if (object is String) {
    print('$name: $object\n');
  } else {
    final prettyString = const JsonEncoder.withIndent('  ').convert(object);
    print('$name:\n$prettyString\n${formatBytes(prettyString.length)}\n');
  }
}

class VdspShareCredentialsPage extends HookConsumerWidget {
  static String routePath = VdspShareCredentialsRoutePath.base;

  const VdspShareCredentialsPage({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final provider = sharedPageControllerProvider(profileId: profileId);
    final state = ref.watch(provider);
    final navigation = ref.read(navigationServiceProvider);

    final vault = ref.read(vaultServiceProvider).currentVault;

    print('messaging DID: ${vault?.messagingDid}');

    // TODO: update this function to use what is required to setup ACL
    Future<void> _configureAcl({
      // required DidManager didManager,
      // required List<String> theirDids,
      required String verifierDid,
      DateTime? expiresTime,
    }) async {
      final ownDidDocument = await vault!.didManager.getDidDocument();
      final didManager = vault!.didManager;

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

      prettyPrint('Initializing DidcommMediator Client');
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
        expiresTime: expiresTime,
      );

      prettyPrint('Sending ACL Management Message to mediator...');
      await mediatorClient.sendAclManagementMessage(accessListAddMessage);
    }

    void showReceivedMessageAlert() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          insetPadding: const EdgeInsets.all(AppSizing.paddingRegular),
          title: Text('Incoming Request'),
          content: Text('The Verifier is requesting for your credentials...'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }

    Future<void> startListeningForMessages() async {
      prettyPrint('Listening for messages....');
      vault?.listenForVdspRequests(
        onDataRequest: (message) async {
          prettyPrint('**** message', object: message);
          showReceivedMessageAlert();
          // if (defaultProfile.defaultCredentialStorage == null) {
          //   throw Exception(
          //     'Default Credential Storage was not configured in the vault',
          //   );
          // }

          // Here you can select a profile and storage if you have multiple ones.
          // For simplicity, we use the default profile and its default credential storage.
          // final queryResult = await vault.filterCredentialsForVdspQueryDataMessage(
          //   message,
          //   credentialStorage: defaultProfile.defaultCredentialStorage!,
          // );

          // if (!queryResult.dcqlResult!.fulfilled) {
          //   prettyPrint(
          //     'No credentials matched the query criteria',
          //     object: queryResult.dcqlResult,
          //   );
          //   return;
          // }

          // Make sure a user reviews which credentials will be shared
          // prettyPrint(
          //   'Credentials matching the query',
          //   object: queryResult.verifiableCredentials,
          // );

          // await vault.sendVdspDataResponse(
          //   requestMessage: message,
          //   verifiableCredentials: queryResult.verifiableCredentials,
          //   profile: defaultProfile,
          //   verifiablePresentationDataModel: VerifiableCredentialsDataModel.v1,
          // );
        },
        onProblemReport: (message) async {
          prettyPrint('A problem has occurred', object: message);
          await ConnectionPool.instance.stopConnections();
        },
      );
    }

    void showSuccessfulScanDialog(String verifierDid) async {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          insetPadding: const EdgeInsets.all(AppSizing.paddingRegular),
          title: Text('QR Code Scan Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Verifier DID: $verifierDid'),
              const SizedBox(height: AppSizing.paddingSmall),
              Text('Allow this verifier to request your credentials via VDSP?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                // TODO: setup ACL, start listener then open connection pool!
                await _configureAcl(verifierDid: verifierDid);
                await startListeningForMessages();
                await ConnectionPool.instance.startConnections();
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      );
    }

    void showInvalidScannedQrCode() async {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          insetPadding: const EdgeInsets.all(AppSizing.paddingRegular),
          title: Text('Scanned QR Code is invalid'),
          content: Text('Please scan a valid QR Code.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }

    void openQrScanner() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) {
            final controller = MobileScannerController();
            var isProcessing = false;
            return Scaffold(
              appBar: AppBar(title: Text(localizations.scanVerifierQrCode)),
              body: MobileScanner(
                controller: controller,
                onDetect: (capture) async {
                  if (isProcessing) return;
                  isProcessing = true;

                  final code = capture.barcodes.first.rawValue;
                  if (code != null) {
                    await controller.stop();
                    Navigator.of(ctx).pop();
                    await Future.delayed(const Duration(milliseconds: 100));
                    final didReg = RegExp(
                      r'^did:[a-z0-9]+:[a-zA-Z0-9.\-]+(/.*)?(#.*)?$',
                    );
                    if (didReg.hasMatch(code)) {
                      showSuccessfulScanDialog(code);
                    } else {
                      isProcessing = false;
                      showInvalidScannedQrCode();
                      // ScaffoldMessenger.of(ctx).showSnackBar(
                      //   const SnackBar(
                      //     content: Text('Scanned value is not a valid DID'),
                      //     duration: Duration(seconds: 3),
                      //   ),
                      // );
                    }
                  }
                },
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColorScheme.backgroundWhite,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.sharedStorages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: openQrScanner,
                    child: Text(localizations.scanVerifierQrCode),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSizing.paddingMedium),
              itemCount: state.sharedStorages.length,
              itemBuilder: (context, index) {
                final storage = state.sharedStorages[index];
                return SharedProfileCard(
                  title: localizations.sharedFromLabel(storage.id),
                  subtitle: localizations.storageTypeLabel(
                    storage.runtimeType.toString(),
                  ),
                  onPressed: () {
                    navigation.push(
                      ProfilesRoutePath.profileSharedProfileDetailsFiles(
                        profileId,
                        storage.id,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
