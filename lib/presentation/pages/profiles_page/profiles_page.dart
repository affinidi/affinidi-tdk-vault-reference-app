import 'dart:developer';
import 'dart:convert';
import 'package:affinidi_tdk_didcomm_mediator_client/affinidi_tdk_didcomm_mediator_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../../widgets/vdsp/vdsp_credential_selector.dart';
import '../../widgets/vdsp/vdsp_dialogs.dart';
import '../../widgets/vdsp/vdsp_profile_selector.dart';
import 'profiles_page_controller.dart';
import 'widgets/profiles_list.dart';

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

    final navigation = ref.read(navigationServiceProvider);

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
            showProfileSelector(context);
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
            // showNoMatchingCredentialsDialog(context);
            showMessageDialog(
              context,
              MessageDialog(
                'No credentials found',
                'No matching credentials found for the query provided.',
              ),
            );

            // NOTE: Should we send back a response to the verifier that there was no credentials matched?
            return;
          }

          if (!context.mounted) return;
          final selectedCredentials = await showCredentialSelection(
            context,
            queryResult.verifiableCredentials,
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
            verifiableCredentials: selectedCredentials,
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TdkAppBar(
        showBackButton: true,
        onBackPressed: () {
          controller.resetCurrentVault();
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
              ],
            )
          : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppSizing.paddingSmall,
                right: AppSizing.paddingLarge,
                top: AppSizing.paddingSmall,
                bottom: AppSizing.paddingRegular,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppSizing.paddingRegular,
                    ),
                    child: Text(
                      currentVaultId != null
                          ? vaultRegistry[currentVaultId]?.vaultName ?? 'Vault'
                          : 'Vault',
                      style: AppTheme.headingXLarge,
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: localizations.vaultSettingsPageHeader,
                    onPressed: () {
                      navigation.push(
                        '${ProfilesRoutePath.base}/${ProfilesRoutePath.vaultSettings}',
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(height: 1.0, color: AppColorScheme.divider),
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
