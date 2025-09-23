import 'package:flutter/material.dart';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart'; // Added for GoRouterState
import '../../../application/services/vault/vault_service.dart';

import '../../../application/services/vaults_manager/vaults_manager_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/vaults/vaults_route_constants.dart';
import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';
import '../../widgets/code_snippet/code_snippet_locations.dart';
import '../../widgets/code_snippet/code_snippet_widget.dart';
import '../../widgets/simple_info_widget.dart';
import '../../widgets/tdk_app_bar.dart';

import 'vaults_page_controller.dart';

class VaultsPage extends ConsumerWidget {
  const VaultsPage({super.key});
  static String get routePath => '/vaults';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final vaultPageState = ref.watch(vaultsPageControllerProvider);
    final vaultEntries = vaultPageState.vaultsById.entries.toList();
    final vaultRegistry = ref.watch(vaultsManagerServiceProvider).vaultRegistry;
    final navigation = ref.read(navigationServiceProvider);

    return Scaffold(
      backgroundColor: AppColorScheme.backgroundWhite,
      appBar: TdkAppBar(
        actions: [
          CodeSnippetWidget(
            title: localizations.lblCSListVaults,
            codeLocations: CodeSnippetLocations.listVaultsSnippets(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: AppSizing.paddingLarge,
                  right: AppSizing.paddingLarge,
                  top: AppSizing.paddingXXLarge,
                  bottom: AppSizing.paddingRegular),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.myVaults.substring(
                        0, localizations.myVaults.indexOf(localizations.myVaults.split(' ').skip(1).join(' '))),
                    style: AppTheme.headingXLarge,
                  ),
                  SimpleInfoWidget(
                    text: localizations.myVaults.split(' ').skip(1).join(' '),
                    dialogTitle: localizations.infoVault,
                    dialogContent: localizations.infoVaultDescription,
                    textStyle: AppTheme.headingXLarge,
                  ),
                ],
              ),
            ),
            Container(
              height: 1.0,
              color: AppColorScheme.divider,
            ),
            Expanded(
              child: vaultPageState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : vaultEntries.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock_outline, size: AppSizing.iconXXLarge, color: theme.colorScheme.primary),
                              const SizedBox(height: AppSizing.paddingMedium),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: AppSizing.paddingXXLarge),
                                child: Text(
                                  localizations.vaultsEmptyMessage,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSizing.paddingLarge),
                          itemCount: vaultEntries.length,
                          itemBuilder: (context, index) {
                            final entry = vaultEntries[index];
                            final vaultName = vaultRegistry[entry.key]?.vaultName;
                            final vault = entry.value;
                            final seed = entry.key;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSizing.paddingRegular),
                              child: Dismissible(
                                key: ValueKey(entry.key),
                                direction: DismissDirection.endToStart,
                                dismissThresholds: const {
                                  DismissDirection.startToEnd: 0.4,
                                },
                                background: SwipeToDeleteBackground(),
                                confirmDismiss: (_) async {
                                  final currentVaultId = ref.read(vaultServiceProvider).currentVaultId;
                                  if (currentVaultId == seed) {
                                    ref.read(vaultServiceProvider.notifier).resetCurrentVault();
                                  }
                                  await ref.read(vaultsPageControllerProvider.notifier).deleteVault(seed);
                                  return true;
                                },
                                child: _VaultCard(
                                  vaultName: vaultName ?? '',
                                  vault: vault,
                                  onSelected: (vault) async {
                                    await ref.read(vaultsPageControllerProvider.notifier).selectVault(seed);
                                    if (!context.mounted) return;
                                    navigation.push(
                                      VaultsRoutePath.openVaultWithId(seed),
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (!context.mounted) return;
          context.push(VaultsRoutePath.create);
        },
        backgroundColor: AppTheme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizing.paddingXXLarge),
        ),
        elevation: 0,
        extendedPadding:
            const EdgeInsets.symmetric(horizontal: AppSizing.paddingMedium, vertical: AppSizing.paddingMedium),
        icon: Icon(
          Icons.add,
          color: AppColorScheme.backgroundWhite,
          size: AppSizing.iconSmall,
        ),
        label: Text(
          localizations.addVault,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColorScheme.backgroundWhite),
        ),
      ),
    );
  }
}

class _VaultCard extends StatelessWidget {
  final Vault vault;
  final String vaultName;
  final void Function(Vault vault) onSelected;

  const _VaultCard({
    required this.vault,
    required this.vaultName,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColorScheme.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizing.paddingSmall),
      ),
      child: InkWell(
        onTap: () => onSelected(vault),
        borderRadius: BorderRadius.circular(AppSizing.paddingSmall),
        child: Padding(
          padding: const EdgeInsets.all(AppSizing.paddingMedium),
          child: Row(
            children: [
              // Vault icon
              SvgPicture.asset(
                'assets/icons/vault-icon.svg',
                width: AppSizing.iconSmall,
                height: AppSizing.iconSmall,
              ),
              const SizedBox(width: AppSizing.paddingMedium),

              Expanded(
                child: Text(
                  vaultName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(letterSpacing: 0.2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.chevron_right,
                  color: AppColorScheme.textPrimary,
                  size: AppSizing.iconSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SwipeToDeleteBackground extends StatelessWidget {
  const SwipeToDeleteBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 28.0, end: 40.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (context, size, _) {
            return Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: AppSizing.paddingLarge),
              decoration: BoxDecoration(
                color: AppColorScheme.error,
                borderRadius: BorderRadius.circular(AppSizing.paddingSmall),
              ),
              child: Icon(
                Icons.delete,
                color: AppColorScheme.backgroundWhite,
                size: size,
              ),
            );
          },
        );
      },
    );
  }
}
