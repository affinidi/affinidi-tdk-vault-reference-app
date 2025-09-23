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

class ProfilesPage extends ConsumerWidget {
  const ProfilesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final controller = ref.read(profilesPageControllerProvider.notifier);
    final profiles = ref.watch(profilesPageControllerProvider.select((state) => state.profiles ?? []));
    final currentVaultId = ref.watch(vaultServiceProvider.select((state) => state.currentVaultId));
    final vaultRegistry = ref.watch(vaultsManagerServiceProvider.select((state) => state.vaultRegistry));
    final navigation = ref.read(navigationServiceProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TdkAppBar(
        showBackButton: true,
        onBackPressed: () {
          controller.resetCurrentVault();
          final navigation = ref.read(navigationServiceProvider);
          navigation.go(VaultsRoutePath.base);
        },
        actions: [
          CodeSnippetWidget(
            title: localizations.lblCSListVaultProfiles,
            codeLocations: CodeSnippetLocations.listVaultProfilesSnippets(context),
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
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColorScheme.backgroundWhite),
              ),
              icon: const Icon(Icons.add),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: AppSizing.paddingRegular),
                    child: Text(
                      currentVaultId != null ? vaultRegistry[currentVaultId]?.vaultName ?? 'Vault' : 'Vault',
                      style: AppTheme.headingXLarge,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1.0,
              color: AppColorScheme.divider,
            ),
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
                            padding: const EdgeInsets.all(AppSizing.paddingLarge),
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
                                      localizations.profilesEmptyStateDescription.substring(
                                          0,
                                          localizations.profilesEmptyStateDescription
                                              .indexOf(localizations.targetKeywordProfiles)),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    SimpleInfoWidget(
                                      text: localizations.targetKeywordProfiles,
                                      dialogTitle: localizations.infoProfile,
                                      dialogContent: localizations.infoProfileDescription,
                                      textStyle: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      ' yet.',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                )),
                                Text(
                                  localizations.profilesEmptyStateDescription
                                      .substring(localizations.profilesEmptyStateDescription.indexOf('Start')),
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
                                      backgroundColor: AppColorScheme.backgroundWhite,
                                      foregroundColor: AppTheme.colorScheme.primary,
                                      side: BorderSide(color: AppColorScheme.divider),
                                      padding: const EdgeInsets.symmetric(vertical: AppSizing.paddingMedium),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(AppSizing.paddingXXLarge),
                                      ),
                                      splashFactory: InkRipple.splashFactory,
                                    ),
                                    child: Text(
                                      localizations.createProfile,
                                      style: const TextStyle(
                                        fontFamily: 'Figtree',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
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
                              padding: EdgeInsets.only(bottom: AppSizing.paddingRegular),
                              child: ProfileCard(
                                profile: profile,
                                onSelected: (profile) {
                                  if (!context.mounted) return;
                                  navigation.push(ProfilesRoutePath.profileMyFiles(profile.id));
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
