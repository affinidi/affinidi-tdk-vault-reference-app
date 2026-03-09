import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../infrastructure/utils/constants.dart';
import '../../l10n/app_localizations.dart';
import '../../navigation/flows/profiles/profiles_route_constants.dart';
import '../../navigation/navigation_provider.dart';
import '../themes/app_sizing.dart';
import '../themes/app_theme.dart';

class VaultAppBar extends ConsumerWidget {
  const VaultAppBar({
    super.key,
    required this.vaultName,
    this.messagingDid = '',
  });

  final String vaultName;
  final String messagingDid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final navigation = ref.read(navigationServiceProvider);

    return Container(
      color: Colors.white,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(vaultName, style: AppTheme.headingXLarge),

                IconButton(
                  key: Key(KeyConstants.keySettingsButton),
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: localizations?.vaultSettingsPageHeader,
                  onPressed: () {
                    // Navigate to Vault Settings Page (absolute path)
                    navigation.push(
                      '${ProfilesRoutePath.base}/${ProfilesRoutePath.vaultSettings}',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
