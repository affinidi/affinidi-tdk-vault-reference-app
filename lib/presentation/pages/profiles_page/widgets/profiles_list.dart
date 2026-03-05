import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../navigation/flows/profiles/profiles_route_constants.dart';
import '../../../../navigation/navigation_provider.dart';
import '../../../dialogs/create_profile_form/create_profile_form.dart';
import '../../../themes/app_color_scheme.dart';
import '../../../themes/app_sizing.dart';
import '../../../themes/app_theme.dart';
import '../../../widgets/simple_info_widget.dart';
import '../profiles_page_controller.dart';
import 'profile_card.dart';

class ProfilesList extends ConsumerWidget {
  const ProfilesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final profiles = ref.watch(
      profilesPageControllerProvider.select((state) => state.profiles ?? []),
    );

    final navigation = ref.read(navigationServiceProvider);

    return profiles.isEmpty
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
                            localizations.profilesEmptyStateDescription.indexOf(
                              localizations.targetKeywordProfiles,
                            ),
                          ),
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
                    ),
                  ),
                  Text(
                    localizations.profilesEmptyStateDescription.substring(
                      localizations.profilesEmptyStateDescription.indexOf(
                        'Start',
                      ),
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
                        backgroundColor: AppColorScheme.backgroundWhite,
                        foregroundColor: AppTheme.colorScheme.primary,
                        side: BorderSide(color: AppColorScheme.divider),
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
                    navigation.push(
                      ProfilesRoutePath.profileMyFiles(profile.id),
                    );
                  },
                ),
              );
            },
          );
  }
}
