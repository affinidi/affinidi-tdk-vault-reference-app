import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/services/vault/vault_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/profiles/profiles_route_constants.dart';
import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../themes/app_theme.dart';
import '../../widgets/code_snippet/code_snippet_locations.dart';
import '../../widgets/code_snippet/code_snippet_widget.dart';
import '../../widgets/tdk_app_bar.dart';
import '../../widgets/vdsp/vdsp_dialogs.dart';
import '../../widgets/vdsp/vdsp_listener.dart';
import '../profiles_page/widgets/qr_scanner_page.dart';
import '../profiles_page/widgets/vdsp_dialogs.dart'
    hide showScanConfirmationDialog, VdspDialogChoice;

class VaultSettingsPage extends ConsumerWidget {
  const VaultSettingsPage({super.key});

  void handleScanNewVerifier(BuildContext context) async {
    final scannedDid = await QrScannerPage.scan(context);

    if (scannedDid == null) return;
    final didReg = RegExp(r'^did:[a-z0-9]+:[a-zA-Z0-9.-]+(/.)?(#.)?$');

    if (didReg.hasMatch(scannedDid)) {
      if (!context.mounted) return;

      final choice = await showScanConfirmationDialog(context, scannedDid);
      if (choice != VdspDialogChoice.ok) return;

      // await controller.allowNewVerifier(scannedDid);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A new verifier has been added to your allow list.'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      if (!context.mounted) return;

      await showInvalidScannedQrCode(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final navigation = ref.read(navigationServiceProvider);
    final vaultMessagingDid = ref
        .read(vaultServiceProvider)
        .currentVault
        ?.messagingDid;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: TdkAppBar(
        showBackButton: true,
        onBackPressed: () => navigation.go(ProfilesRoutePath.base),
        actions: [
          CodeSnippetWidget(
            title: localizations.lblCSViewVaultProfile,
            codeLocations: CodeSnippetLocations.viewVaultProfileSnippets(
              context,
            ),
          ),
        ],
      ),
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
                    padding: const EdgeInsets.only(
                      left: AppSizing.paddingMedium,
                      top: AppSizing.paddingLarge,
                    ),
                    child: Text(
                      localizations.vaultSettingsPageHeader,
                      style: AppTheme.headingMedium,
                    ),
                  ),
                  const SizedBox(height: AppSizing.paddingMedium),
                  const Divider(height: 1, color: AppColorScheme.divider),
                ],
              ),
            ),

            Container(height: 1.0, color: AppColorScheme.divider),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizing.paddingMedium,
                ),
                children: [
                  // Display Messaging DID Qr Code
                  _SettingsTile(
                    icon: Icons.message_rounded,
                    title: localizations.displayMessagingDidLabel,
                    onTap: () => showMessagingDidDialog(
                      context,
                      vaultMessagingDid ?? '',
                    ),
                  ),
                  const SizedBox(height: AppSizing.paddingSmall),

                  // Enable / Disable VDSP Listener
                  _SettingsTile(
                    icon: Icons.on_device_training_outlined,
                    title: localizations.toggleVdspListenerLabel,
                    // TODO: use the vdspListenerState to be obtained somewhere
                    onTap: () => showVdspListenerSettings(context, false),
                  ),
                  const SizedBox(height: AppSizing.paddingSmall),

                  // Scan New Verifier
                  _SettingsTile(
                    icon: Icons.qr_code_scanner_rounded,
                    title: localizations.scanNewVerifierLabel,
                    onTap: () => handleScanNewVerifier(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor,
    this.iconColor,
    super.key,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColorScheme.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizing.paddingSmall),
        side: BorderSide(color: AppColorScheme.divider),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? AppColorScheme.textPrimary),
        title: Text(title, style: Theme.of(context).textTheme.labelLarge),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: AppSizing.iconXSmall,
          color: AppColorScheme.iconInfo,
        ),
        onTap: onTap,
      ),
    );
  }
}
