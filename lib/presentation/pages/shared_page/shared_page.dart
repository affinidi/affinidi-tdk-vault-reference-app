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

    return Scaffold(
      backgroundColor: AppColorScheme.backgroundWhite,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.sharedStorages.isEmpty
              ? Center(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    localizations.noSharedContentAvailable.substring(
                        0, localizations.noSharedContentAvailable.indexOf(localizations.targetKeywordSharedContent)),
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
                        localizations.noSharedContentAvailable.lastIndexOf(localizations.targetKeywordSharedContent) +
                            localizations.targetKeywordSharedContent.length,
                        localizations.noSharedContentAvailable.length),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ]))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSizing.paddingMedium),
                  itemCount: state.sharedStorages.length,
                  itemBuilder: (context, index) {
                    final storage = state.sharedStorages[index];
                    return SharedProfileCard(
                      title: localizations.sharedFromLabel(storage.id),
                      subtitle: localizations.storageTypeLabel(storage.runtimeType.toString()),
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
