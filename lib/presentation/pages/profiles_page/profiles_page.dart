import 'dart:developer';
import 'dart:convert';
import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../application/services/vaults_manager/vaults_manager_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/vaults/vaults_route_constants.dart';
import '../../../navigation/navigation_provider.dart';
import '../../dialogs/create_profile_form/create_profile_form.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';
import '../../widgets/loading_status/async_loading_status.dart';
import '../../widgets/tdk_app_bar.dart';
import '../../widgets/code_snippet/code_snippet_widget.dart';
import '../../widgets/code_snippet/code_snippet_locations.dart';
import 'profiles_page_controller.dart';
import 'widgets/vdsp_profile_selector.dart';
import 'widgets/profiles_list.dart';
import 'widgets/qr_scanner_page.dart';
import 'widgets/vdsp_dialogs.dart';

class ProfilesPage extends ConsumerWidget {
  const ProfilesPage({super.key});

  String getVcDetails(dynamic credentials, String key) {
    Map<String, dynamic> credentialDataMap;
    if (credentials is String) {
      credentialDataMap = jsonDecode(credentials) as Map<String, dynamic>;
    } else if (credentials is Map<String, dynamic>) {
      credentialDataMap = credentials;
    } else {
      try {
        credentialDataMap =
            (credentials as dynamic).toJson() as Map<String, dynamic>;
      } catch (_) {
        credentialDataMap =
            jsonDecode(jsonEncode(credentials)) as Map<String, dynamic>;
      }
    }

    final value = credentialDataMap[key];
    if (value == null) return 'Invalid key';

    if (value is List) {
      if (value.isEmpty) return 'Invalid key';

      final selectedData = value.length > 1 ? value[1] : value[0];
      return selectedData.toString();
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final controller = ref.read(profilesPageControllerProvider.notifier);
    final profiles = ref.watch(
      profilesPageControllerProvider.select((state) => state.profiles ?? []),
    );
    final currentVaultId = ref.watch(
      vaultServiceProvider.select((state) => state.currentVaultId),
    );
    final vaultRegistry = ref.watch(
      vaultsManagerServiceProvider.select((state) => state.vaultRegistry),
    );

    void handleVdspListenerEvents() {
      controller.vdspRequests.listen(
        (message) async {
          if (!context.mounted) return;
          final userChoice = await showIncomingRequestDialog(context);

          if (userChoice != VdspDialogChoice.ok) {
            log('Denying VDSP request with id ${message.id}');
            return;
          }

          if (!context.mounted) return;
          final selectedProfile = await showProfileSelector(context);

          if (selectedProfile?.defaultCredentialStorage == null) {
            prettyPrint('User did not select any profile');

            if (!context.mounted) return;
            showProfileSelectCanceledDialog(context);
            // NOTE: Should we send back a response to the verifier that the user canceled?
            return;
          }

          final queryResult = await controller.filterCredentialsForVdsp(
            message,
            credentialStorage: selectedProfile?.defaultCredentialStorage!,
          );

          if (!queryResult.dcqlResult!.fulfilled) {
            prettyPrint('No credentials matching the holder`s profile.');

            if (!context.mounted) return;
            showNoMatchingCredentialsDialog(context);

            // NOTE: Should we send back a response to the verifier that there was no credentials matched?
            return;
          }

          final selectedCredentials =
              // TODO: Need to have a separate widget for this
              // instead of using modal bottom sheet.
              await showModalBottomSheet<List<dynamic>>(
                context: context,
                isScrollControlled: true,
                builder: (ctx) {
                  final creds =
                      queryResult.verifiableCredentials ?? <dynamic>[];
                  final selectedIndexes = <int>{};
                  return StatefulBuilder(
                    builder: (ctx, setState) {
                      return SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 20,
                                ),
                                child: Text(
                                  'Select credentials to share',
                                  style: Theme.of(ctx).textTheme.titleMedium,
                                ),
                              ),

                              // TODO: TOO MUCH CLUTTER
                              Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: creds.length,
                                  itemBuilder: (c, i) {
                                    final cred = creds[i];
                                    final types = getVcDetails(cred, 'type');
                                    final issuer = getVcDetails(cred, 'issuer');
                                    return CheckboxListTile(
                                      value: selectedIndexes.contains(i),
                                      onChanged: (v) {
                                        setState(() {
                                          if (v == true) {
                                            selectedIndexes.add(i);
                                          } else {
                                            selectedIndexes.remove(i);
                                          }
                                        });
                                      },
                                      title: Text(types),
                                      subtitle: issuer.isNotEmpty
                                          ? Text(issuer)
                                          : null,
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(null),
                                    child: const Text('Cancel'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      final picked = selectedIndexes
                                          .map((i) => creds[i])
                                          .toList();
                                      Navigator.of(ctx).pop(picked);
                                    },
                                    child: const Text('Share'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );

          if (selectedCredentials == null || selectedCredentials.isEmpty) {
            log(
              'User cancelled or selected no credentials to share for message with id ${message.id}',
            );
            return;
          }

          log(
            'Credentials matching the query for message with id ${message.id}',
          );

          await controller.sendVdspDataResponse(
            requestMessage: message,
            verifiableCredentials: queryResult.verifiableCredentials,
            profile: selectedProfile,
          );

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Response was sent back to the verifier.'),
              duration: Duration(seconds: 3),
            ),
          );

          // TODO: Maybe trigger closing the stream after sending ???
        },
        onError: (message) async {
          log(
            'A problem has occurred with id ${message.id}, stopping listener',
            error: message,
          );
          await controller.stopVdspListener();
        },
      );
    }

    /// Handles the starting of VDSP listener
    void handleToggleVdspListener() async {
      await controller.startVdspListener();
      handleVdspListenerEvents();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('VDSP Listener enabled'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    void handleScanNewVerifier(BuildContext context) async {
      final scannedDid = await QrScannerPage.scan(context);

      if (scannedDid == null) return;
      final didReg = RegExp(r'^did:[a-z0-9]+:[a-zA-Z0-9.-]+(/.)?(#.)?$');

      if (didReg.hasMatch(scannedDid)) {
        if (!context.mounted) return;

        final choice = await showScanConfirmationDialog(context, scannedDid);
        if (choice != VdspDialogChoice.ok) return;

        await controller.allowNewVerifier(scannedDid);

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A new verifier has been added to your allow list.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        if (!context.mounted) return;

        await showInvalidScannedQrCode(context);
      }
    }

    // TODO: we need to display the MessagingDID somewhere.
    // it can be obtained from vault.messagingDid.
    // this is important for the verifier to whitelist or configureACL to allow
    // the holder to send a message back to the verifier.

    return Scaffold(
      backgroundColor: AppColorScheme.backgroundBlack,
      appBar: TdkAppBar(
        leadingTitle: currentVaultId != null
            ? vaultRegistry[currentVaultId]?.vaultName ?? 'Vault'
            : 'Vault',
        titleWidget: SimpleInfoWidget(
          text: localizations.profilesTitle,
          dialogTitle: localizations.infoProfile,
          dialogContent: localizations.infoProfileDescription,
          textStyle: AppTheme.headingLarge,
        ),
        centerTitle: true,
        showBackButton: true,
        onBackPressed: () async {
          await controller.resetCurrentVault();
          final navigation = ref.read(navigationServiceProvider);
          navigation.go(VaultsRoutePath.base);
        },
        actions: [
          CodeSnippetWidget(
            title: localizations.lblCSListVaultProfiles,
            codeLocations: CodeSnippetLocations.listVaultProfilesSnippets(
              context,
            ),
          ),
        ],
      ),
      floatingActionButton: profiles.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    CreateProfileForm.show(context: context);
                  },
                  backgroundColor: AppTheme.colorScheme.primary,
                  foregroundColor: AppColorScheme.backgroundWhite,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizing.paddingXXLarge,
                    ),
                  ),
                  label: Text(
                    localizations.createProfile,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColorScheme.backgroundWhite,
                    ),
                  ),
                  icon: const Icon(Icons.add),
                ),

                const SizedBox(height: AppSizing.paddingSmall),

                /// Start / Stop VDSP Listener Button
                FloatingActionButton.extended(
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    handleToggleVdspListener();
                  },
                  backgroundColor: AppTheme.colorScheme.primary,
                  foregroundColor: AppColorScheme.backgroundWhite,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizing.paddingXXLarge,
                    ),
                  ),
                  label: Text(
                    localizations.enableVdspButtonLabel,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColorScheme.backgroundWhite,
                    ),
                  ),
                  icon: const Icon(Icons.play_circle_outline),
                ),

                const SizedBox(height: AppSizing.paddingSmall),

                /// Scan new verifier button
                FloatingActionButton.extended(
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    handleScanNewVerifier(context);
                  },
                  backgroundColor: AppTheme.colorScheme.primary,
                  foregroundColor: AppColorScheme.backgroundWhite,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizing.paddingXXLarge,
                    ),
                  ),
                  label: Text(
                    localizations.scanNewVerifierButtonLabel,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColorScheme.backgroundWhite,
                    ),
                  ),
                  icon: const Icon(Icons.qr_code_scanner_sharp),
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.refreshProfiles();
                },
                child: AsyncLoadingStatus(
                  controller.loadingController,
                  child: ProfilesList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
