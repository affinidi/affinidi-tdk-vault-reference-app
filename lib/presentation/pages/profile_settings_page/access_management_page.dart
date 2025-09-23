import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';
import '../../widgets/simple_info_widget.dart';
import '../../widgets/tdk_app_bar.dart';
import '../../widgets/code_snippet/code_snippet_widget.dart';
import '../../widgets/code_snippet/code_snippet_locations.dart';
import 'profile_settings_page_controller.dart';

class AccessManagementPage extends ConsumerWidget {
  const AccessManagementPage({
    super.key,
    required this.profileId,
  });

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final controllerProvider = profileSettingsPageControllerProvider(profileId);
    final controller = ref.watch(controllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TdkAppBar(
        actions: [
          CodeSnippetWidget(
            title: localizations.snippetDescRevokeAccess,
            codeLocations: CodeSnippetLocations.revokedAccessSnippets(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header section
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
                const SizedBox(height: AppSizing.paddingSmall),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppSizing.paddingRegular),
                    child: SimpleInfoWidget(
                      text: localizations.accessManagementLabel,
                      dialogTitle: localizations.infoAccessManagement,
                      dialogContent: localizations.infoAccessManagementDescription,
                      textStyle: AppTheme.headingLarge,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizing.paddingMedium),
              ],
            ),
          ),
          // Table header
          Container(
            padding: const EdgeInsets.all(AppSizing.paddingMedium),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA),
              border: Border(
                bottom: BorderSide(color: AppColorScheme.divider),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    localizations.profileIdHeader,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColorScheme.textPrimary),
                  ),
                ),
                SizedBox(width: AppSizing.paddingSmall),
                SizedBox(
                  width: 120,
                  child: Text(
                    localizations.didHeader,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                SizedBox(width: AppSizing.paddingSmall),
                SizedBox(
                  width: 94,
                  child: Text(
                    localizations.permissionsHeader,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 47,
                  child: Text(
                    localizations.actionHeader,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          // Table content
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final sharedAccessesAsync = ref.watch(sharedProfileAccessesProvider(profileId));
                return sharedAccessesAsync.when(
                  data: (sharedList) {
                    if (sharedList.isEmpty) {
                      return Padding(
                          padding: const EdgeInsets.all(AppSizing.paddingMedium),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  localizations.noSharedDidsForProfile,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ));
                    }
                    final revokingIds = ref.watch(controllerProvider.select((state) => state.revokingIds));
                    return ListView.separated(
                      itemCount: sharedList.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        color: AppColorScheme.divider,
                      ),
                      itemBuilder: (context, index) {
                        final entry = sharedList[index];
                        final isRevoking = revokingIds.contains(entry.id);
                        return Container(
                          padding: const EdgeInsets.all(AppSizing.paddingMedium),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  entry.profileId.length > 8
                                      ? '${entry.profileId.substring(0, 8)}...'
                                      : entry.profileId,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 120,
                                child: Text(
                                  entry.receiverDid.length > 12
                                      ? '${entry.receiverDid.substring(0, 12)}...'
                                      : entry.receiverDid,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  entry.accessLevel == 'read' ? 'View Only' : 'Can Write',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 50,
                                child: isRevoking
                                    ? const Center(
                                        child: SizedBox(
                                          width: AppSizing.iconSmall,
                                          height: AppSizing.iconSmall,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      )
                                    : IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle,
                                          color: AppColorScheme.error,
                                          size: AppSizing.iconSmall,
                                        ),
                                        tooltip: localizations.revokeAccessTooltip,
                                        onPressed: () {
                                          controller.revokeAccess(
                                            entryId: entry.id,
                                            profileId: entry.profileId,
                                            receiverDid: entry.receiverDid,
                                          );
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text(
                      localizations.genericError(error),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColorScheme.textSecondary),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
