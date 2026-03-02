// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/flows/profiles/profiles_route_constants.dart';
import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_theme.dart';
import 'profile_page_controller.dart';
import '../../widgets/profile/profile_app_bar.dart';
import '../../widgets/tdk_app_bar.dart';
import '../../widgets/code_snippet/code_snippet_widget.dart';
import '../../widgets/code_snippet/code_snippet_locations.dart';
import '../../../l10n/app_localizations.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage(
      {super.key, required this.navigationShell, required this.profileId});

  final StatefulNavigationShell navigationShell;
  final String profileId;

  @override
  Widget build(BuildContext context, ref) {
    final provider = profilePageControllerProvider(profileId: profileId);
    final profile = ref.watch(provider.select((state) => state.profile));
    final localizations = AppLocalizations.of(context)!;
    final navigation = ref.read(navigationServiceProvider);

    final navigationItems = useMemoized(
      () => [
        NavigationItem(
          localizedLabel: localizations.myFiles,
          icon: Icons.folder,
        ),
        NavigationItem(
          localizedLabel: localizations.myCredentials,
          icon: Icons.badge,
        ),
        NavigationItem(
          localizedLabel: localizations.shared,
          icon: Icons.share,
        ),
      ],
      [localizations],
    );

    return Scaffold(
      backgroundColor: AppColorScheme.backgroundBlack,
      resizeToAvoidBottomInset: false,
      appBar: TdkAppBar(
        title: profile?.name ?? '',
        showBackButton: true,
        onBackPressed: () => navigation.go(
          ProfilesRoutePath.base,
        ),
        actions: [
          CodeSnippetWidget(
            title: localizations.lblCSViewVaultProfile,
            codeLocations:
                CodeSnippetLocations.viewVaultProfileSnippets(context),
          ),
        ],
      ),
      body: Column(
        children: [
          ProfileAppBar(
            profileName: profile?.name ?? '',
            profileDescription: profile?.description ?? '',
            profileId: profileId,
            profileDid: profile?.did ?? '',
          ),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColorScheme.backgroundBlack,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        selectedItemColor: AppTheme.colorScheme.primary,
        unselectedItemColor: AppColorScheme.textSecondary,
        selectedLabelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppTheme.colorScheme.primary,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColorScheme.textSecondary,
            ),
        items: navigationItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.localizedLabel,
              ),
            )
            .toList(),
      ),
    );
  }
}

class NavigationItem {
  const NavigationItem({
    required this.localizedLabel,
    required this.icon,
  });
  final String localizedLabel;
  final IconData icon;
}
