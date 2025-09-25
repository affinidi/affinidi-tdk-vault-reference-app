import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../navigation/flows/profiles/profiles_route_constants.dart';
import '../../../navigation/navigation_provider.dart';
import '../../../l10n/app_localizations.dart';

class SharedProfileDetailsPage extends HookConsumerWidget {
  const SharedProfileDetailsPage({
    super.key,
    required this.navigationShell,
    required this.profileId,
    required this.sharedProfileId,
  });

  final StatefulNavigationShell navigationShell;
  final String profileId;
  final String sharedProfileId;

  @override
  Widget build(BuildContext context, ref) {
    final localizations = AppLocalizations.of(context)!;
    final navigation = ref.read(navigationServiceProvider);

    final navigationItems = useMemoized(
      () => [
        _NavigationItem(
          localizedLabel: localizations.files,
          icon: Icons.folder,
        ),
        _NavigationItem(
          localizedLabel: localizations.credentials,
          icon: Icons.badge,
        ),
      ],
      [localizations],
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        context.go(ProfilesRoutePath.profileShared(
          profileId,
        ));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(localizations.sharedProfileDetails),
          leading: BackButton(onPressed: () {
            if (context.mounted) {
              navigation.pop();
            }
          }),
        ),
        body: Column(
          children: [
            Expanded(child: navigationShell),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index),
          items: navigationItems
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.localizedLabel,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.localizedLabel,
    required this.icon,
  });
  final String localizedLabel;
  final IconData icon;
}
