import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart'
    hide CredentialFormat;
// import 'package:didcomm/didcomm.dart' hide AccessListAddMessage;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../application/services/vault/vault_service.dart';
import '../../../application/services/vaults_manager/vaults_manager_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/profiles/profiles_route_constants.dart';
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
import '../../widgets/simple_info_widget.dart';

import 'profiles_page_controller.dart';
import 'widgets/profile_card.dart';
import 'widgets/qr_scanner_page.dart';

class ProfilesPage extends ConsumerWidget {
  const ProfilesPage({super.key});

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
    final navigation = ref.read(navigationServiceProvider);

    // TODO: we need to display the MessagingDID somewhere.
    // it can be obtained from vault.messagingDid.
    // this is important for the verifier to whitelist or configureACL to allow
    // the holder to send a message back to the verifier.

    Future<String> showReceivedMessageAlert() async {
      final selectedOption = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          insetPadding: const EdgeInsets.all(AppSizing.paddingRegular),
          title: Text('Incoming Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Verifier is requesting for a credential.'),
              const SizedBox(height: AppSizing.paddingSmall),
              const Text('Do you want to allow this request?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop('CANCEL');
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop('OK');
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      );

      return selectedOption ?? 'CANCEL';
    }

    // TODO: This should be moved to widgets instead.
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
              const Text(
                'Allow this verifier to request your credentials via VDSP?',
              ),
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

                await controller.startVdspFlow(verifierDid);
                await controller.startVdspListener();

                // TODO: This shouldn't be here. Need to move it somewhere.
                controller.vdspRequests.listen(
                  (message) async {
                    final choice = await showReceivedMessageAlert();
                    if (choice != 'OK') {
                      prettyPrint('User denied incoming request');
                      return;
                    }

                    // TODO: Handle profile selection to allow holder to select
                    // which profile to use where tthe filterCredentials will be
                    // done.
                    final defaultProfile = profiles.first;
                    if (defaultProfile.defaultCredentialStorage == null) {
                      throw Exception(
                        'Default Credential Storage was not configured in the vault',
                      );
                    }

                    final queryResult = await controller
                        .filterCredentialsForVdsp(
                          message,
                          credentialStorage:
                              defaultProfile.defaultCredentialStorage!,
                        );

                    if (!queryResult.dcqlResult!.fulfilled) {
                      prettyPrint(
                        'No credentials matched the query criteria',
                        object: queryResult.dcqlResult,
                      );
                      return;
                    }

                    // TODO: Need to refactor this as it is cluttering
                    // profiles_page too much!
                    final selectedCredentials =
                        // TODO: Need to have a separate widget for this
                        // instead of using modal bottom sheet.
                        await showModalBottomSheet<List<dynamic>>(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) {
                            final creds =
                                queryResult.verifiableCredentials ??
                                <dynamic>[];
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
                                            style: Theme.of(
                                              ctx,
                                            ).textTheme.titleMedium,
                                          ),
                                        ),

                                        // TODO: TOO MUCH CLUTTER
                                        Flexible(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: creds.length,
                                            itemBuilder: (c, i) {
                                              final cred = creds[i];
                                              Map<String, dynamic>
                                              credentialDataMap;
                                              if (cred is String) {
                                                credentialDataMap =
                                                    jsonDecode(cred)
                                                        as Map<String, dynamic>;
                                              } else if (cred
                                                  is Map<String, dynamic>) {
                                                credentialDataMap = cred;
                                              } else {
                                                try {
                                                  credentialDataMap =
                                                      (cred as dynamic).toJson()
                                                          as Map<
                                                            String,
                                                            dynamic
                                                          >;
                                                } catch (_) {
                                                  credentialDataMap =
                                                      jsonDecode(
                                                            jsonEncode(cred),
                                                          )
                                                          as Map<
                                                            String,
                                                            dynamic
                                                          >;
                                                }
                                              }

                                              final types =
                                                  credentialDataMap['type'][1] ??
                                                  'Credential';
                                              final issuer =
                                                  credentialDataMap['issuer'] ??
                                                  '';
                                              return CheckboxListTile(
                                                value: selectedIndexes.contains(
                                                  i,
                                                ),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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

                    if (selectedCredentials == null ||
                        selectedCredentials.isEmpty) {
                      prettyPrint(
                        'User cancelled or selected no credentials to share',
                      );
                      return;
                    }

                    prettyPrint(
                      'Credentials matching the query',
                      object: queryResult.verifiableCredentials,
                    );

                    await controller.sendVdspDataResponse(
                      requestMessage: message,
                      verifiableCredentials: queryResult.verifiableCredentials,
                      profile: defaultProfile,
                    );

                    // TODO: Maybe trigger closing the stream after sending ???
                  },
                  onError: (message) async {
                    prettyPrint('A problem has occurred', object: message);
                    await ConnectionPool.instance.stopConnections();
                  },
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'ACL configured - Listening to VDSP requests',
                    ),
                    duration: Duration(seconds: 6),
                  ),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      );
    }

    // TODO: This should be moved to widgets instead.
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
          ? FloatingActionButton.extended(
              onPressed: () {
                HapticFeedback.lightImpact();
                CreateProfileForm.show(context: context);
              },
              backgroundColor: AppTheme.colorScheme.primary,
              foregroundColor: AppColorScheme.backgroundWhite,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizing.paddingXXLarge),
              ),
              label: Text(
                localizations.createProfile,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColorScheme.backgroundWhite),
              ),
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
                  child: profiles.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              AppSizing.paddingLarge,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/empty-profiles.svg',
                                  width: 242,
                                  height: 242,
                                ),
                                const SizedBox(height: AppSizing.paddingLarge),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        localizations
                                            .profilesEmptyStateDescription
                                            .substring(
                                              0,
                                              localizations
                                                  .profilesEmptyStateDescription
                                                  .indexOf(
                                                    localizations
                                                        .targetKeywordProfiles,
                                                  ),
                                            ),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                      SimpleInfoWidget(
                                        text:
                                            localizations.targetKeywordProfiles,
                                        dialogTitle: localizations.infoProfile,
                                        dialogContent: localizations
                                            .infoProfileDescription,
                                        textStyle: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                      Text(
                                        ' yet.',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  localizations.profilesEmptyStateDescription
                                      .substring(
                                        localizations
                                            .profilesEmptyStateDescription
                                            .indexOf('Start'),
                                      ),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: AppSizing.paddingLarge),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      if (!context.mounted) return;
                                      CreateProfileForm.show(context: context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppTheme.colorScheme.primary,
                                      foregroundColor:
                                          AppColorScheme.backgroundWhite,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: AppSizing.paddingMedium,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppSizing.paddingXXLarge,
                                        ),
                                      ),
                                      splashFactory: InkRipple.splashFactory,
                                    ),
                                    child: Text(
                                      localizations.createProfile,
                                      style: const TextStyle(
                                        fontFamily: 'Figtree',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(AppSizing.paddingMedium),
                          itemCount: profiles.length,
                          itemBuilder: (context, index) {
                            final profile = profiles[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: AppSizing.paddingRegular,
                              ),
                              child: ProfileCard(
                                profile: profile,
                                onSelected: (profile) {
                                  if (!context.mounted) return;
                                  navigation.push(
                                    ProfilesRoutePath.profileMyFiles(
                                      profile.id,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
