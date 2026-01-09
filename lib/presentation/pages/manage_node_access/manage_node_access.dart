import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/tdk_app_bar.dart';

class ManageNodeAccess extends HookConsumerWidget {
  const ManageNodeAccess({
    super.key,
    required this.profileId,
    required this.nodeId,
    required this.nodeName,
  });

  final String profileId;
  final String nodeId;
  final String nodeName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final vaultService = ref.read(vaultServiceProvider.notifier);
    final revokingDids = useState<Set<String>>({});
    final accessList =
        useState<List<({String granteeDid, ItemPermission permission})>>([]);
    final loadingAccess = useState<bool>(true);

    Future<void> loadAccess() async {
      loadingAccess.value = true;
      try {
        // Get all profiles to find grantees
        final vault = ref.read(vaultServiceProvider).currentVault;
        if (vault == null) {
          accessList.value = [];
          loadingAccess.value = false;
          return;
        }

        final profiles = await vault.listProfiles();
        final allAccess = <({String granteeDid, ItemPermission permission})>[];

        for (final profile in profiles) {
          try {
            final permissions = await vaultService.getItemAccess(
              profileId: profileId,
              granteeDid: profile.did,
            );
            // Filter permissions that include this node
            for (final perm in permissions) {
              if (perm.itemIds.contains(nodeId)) {
                allAccess.add((granteeDid: profile.did, permission: perm));
              }
            }
          } catch (e) {
            // Skip if can't get access for this profile
            continue;
          }
        }

        accessList.value = allAccess;
      } catch (e) {
        // On error, set empty list
        accessList.value = [];
      } finally {
        loadingAccess.value = false;
      }
    }

    Future<void> revokeAccess(String granteeDid) async {
      revokingDids.value = {...revokingDids.value, granteeDid};
      try {
        await vaultService.revokeItemAccess(
          profileId: profileId,
          nodeId: nodeId,
          granteeDid: granteeDid,
        );
        // Reload access list
        await loadAccess();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                localizations.accessRevokedMessage,
                style: const TextStyle(color: AppColorScheme.textPrimary),
              ),
              backgroundColor: AppColorScheme.backgroundDark,
              behavior: SnackBarBehavior.fixed,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${localizations.errorRevokingAccess}: $e',
                style: const TextStyle(color: AppColorScheme.textPrimary),
              ),
              backgroundColor: AppColorScheme.backgroundDark,
              behavior: SnackBarBehavior.fixed,
            ),
          );
        }
      } finally {
        revokingDids.value = revokingDids.value..remove(granteeDid);
      }
    }

    useEffect(() {
      loadAccess();
      return null;
    }, []);

    String formatPermissions(List<String> rights) {
      if (rights.contains('vfsRead') && rights.contains('vfsWrite')) {
        return localizations.canWriteLabel;
      } else if (rights.contains('vfsRead')) {
        return localizations.canViewOnlyLabel;
      }
      return rights.join(', ');
    }

    String formatExpiration(DateTime? expiresAt) {
      if (expiresAt == null) return localizations.neverExpires;
      // Convert UTC to local time for display
      final localTime = expiresAt.toLocal();
      // Format as two lines: date on first line, time on second line
      return '${localTime.day}/${localTime.month}/${localTime.year}\n${localTime.hour}:${localTime.minute.toString().padLeft(2, '0')}';
    }

    Widget buildTableHeader() {
      return Container(
        padding: const EdgeInsets.all(AppSizing.paddingMedium),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColorScheme.divider),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                localizations.didHeader,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 11),
              ),
            ),
            const SizedBox(width: AppSizing.paddingSmall),
            Expanded(
              flex: 2,
              child: Text(
                localizations.permissionsHeader,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 11),
              ),
            ),
            const SizedBox(width: AppSizing.paddingSmall),
            Expanded(
              flex: 2,
              child: Text(
                localizations.expiryDate,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 11),
              ),
            ),
            const SizedBox(width: AppSizing.paddingSmall),
            SizedBox(
              width: 50,
              child: Text(
                localizations.actionHeader,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 11),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildTableContent() {
      if (loadingAccess.value) {
        return const Padding(
          padding: EdgeInsets.all(AppSizing.paddingLarge),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (accessList.value.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(AppSizing.paddingLarge),
          child: Center(
            child: Text(
              localizations.noSharedAccessesForNode,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      }

      return Expanded(
        child: ListView.separated(
          itemCount: accessList.value.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            color: AppColorScheme.divider,
          ),
          itemBuilder: (context, index) {
            final entry = accessList.value[index];
            final isRevoking = revokingDids.value.contains(entry.granteeDid);

            return Padding(
              padding: const EdgeInsets.all(AppSizing.paddingMedium),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      entry.granteeDid,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: AppSizing.paddingSmall),
                  Expanded(
                    flex: 2,
                    child: Text(
                      formatPermissions(entry.permission.rights),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: AppSizing.paddingSmall),
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.permission.expiresAt != null
                          ? formatExpiration(entry.permission.expiresAt)
                          : localizations.neverExpires,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSizing.paddingSmall),
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
                            onPressed: () => revokeAccess(entry.granteeDid),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSizing.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizing.paddingMedium),
          buildTableHeader(),
          buildTableContent(),
        ],
      ),
    );
  }
}

class ManageNodeAccessPage extends StatelessWidget {
  const ManageNodeAccessPage({
    super.key,
    required this.profileId,
    required this.nodeId,
    required this.nodeName,
  });

  final String profileId;
  final String nodeId;
  final String nodeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TdkAppBar(
        showBackButton: true,
        title: AppLocalizations.of(context)!.manageAccess,
      ),
      body: SafeArea(
        child: ManageNodeAccess(
          profileId: profileId,
          nodeId: nodeId,
          nodeName: nodeName,
        ),
      ),
    );
  }
}
