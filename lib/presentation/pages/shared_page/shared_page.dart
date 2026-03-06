import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/app_routes.dart';
import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';

import 'shared_page_controller.dart';
import 'widget/shared_profile_card.dart';
import '../../widgets/simple_info_widget.dart';

class SharedPage extends ConsumerWidget {
  const SharedPage({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final provider = sharedPageControllerProvider(profileId: profileId);
    final state = ref.watch(provider);
    final navigation = ref.read(navigationServiceProvider);

    final hasSharedContent =
        state.sharedStorages.isNotEmpty || state.granularAccessItems.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColorScheme.backgroundBlack,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : !hasSharedContent
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.noSharedContentAvailable.substring(
                      0,
                      localizations.noSharedContentAvailable.indexOf(
                        localizations.targetKeywordSharedContent,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SimpleInfoWidget(
                    text: localizations.targetKeywordSharedContent,
                    dialogTitle: localizations.infoShareContent,
                    dialogContent: localizations.infoShareContentDescription,
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    localizations.noSharedContentAvailable.substring(
                      localizations.noSharedContentAvailable.lastIndexOf(
                            localizations.targetKeywordSharedContent,
                          ) +
                          localizations.targetKeywordSharedContent.length,
                      localizations.noSharedContentAvailable.length,
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSizing.paddingMedium),
              children: [
                // Profile-shared storages
                ...state.sharedStorages.map((storage) {
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
                }),
                // Granular access items
                ...state.granularAccessItems.map((item) {
                  String permissionsText = '';
                  if (item.rights.contains('vfsRead') &&
                      item.rights.contains('vfsWrite')) {
                    permissionsText = localizations.canWriteLabel;
                  } else if (item.rights.contains('vfsRead')) {
                    permissionsText = localizations.canViewOnlyLabel;
                  } else {
                    permissionsText = item.rights.join(', ');
                  }

                  return SharedProfileCard(
                    title: localizations.sharedFromNodeLabel(
                      item.ownerProfileName,
                    ),
                    subtitle: '${item.nodeName} • $permissionsText',
                    onPressed: () {
                      if (item.isFolder) {
                        navigation.push(
                          '${ProfilesRoutePath.profileMyFiles(item.ownerProfileId)}?folder=${item.nodeId}',
                        );
                      } else {
                        navigation.push(
                          ProfilesRoutePath.profileFilePreview(
                            item.ownerProfileId,
                            item.nodeId,
                          ),
                        );
                      }
                    },
                  );
                }),
              ],
            ),
    );
  }
}
