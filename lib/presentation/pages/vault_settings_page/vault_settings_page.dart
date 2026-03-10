import 'package:didcomm/didcomm.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/flows/profiles/profiles_route_constants.dart';
import '../../../navigation/navigation_provider.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/qr_scanner.dart';
import '../../widgets/tdk_app_bar.dart';
import '../../widgets/vdsp/vdsp_dialogs.dart';
import '../../widgets/vdsp/vdsp_listener.dart';
import 'vault_settings_page_controller.dart';

class VaultSettingsPage extends ConsumerWidget {
  const VaultSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final navigation = ref.read(navigationServiceProvider);

    final controller = ref.read(vaultSettingsPageControllerProvider.notifier);

    final vaultMessagingDid = ref
        .read(vaultServiceProvider)
        .currentVault
        ?.messagingDid;

    final listenerStatus = ref.watch(
      vaultServiceProvider.select((s) => s.isVdspListenerEnabled),
    );

    void handleScanNewVerifier(BuildContext context) async {
      final scannedDid = await QrScanner.scan(context);

      if (scannedDid == null) return;
      final didReg = RegExp(r'^did:[a-z0-9]+:[a-zA-Z0-9.-]+(/.)?(#.)?$');

      if (didReg.hasMatch(scannedDid)) {
        if (!context.mounted) return;

        final choice = await showScanConfirmationDialog(context, scannedDid);
        if (choice != VdspDialogChoice.ok) return;

        await controller.whitelistVerifierDid(scannedDid);

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'A new verifier has been added to your allow list.',
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: AppColorScheme.backgroundLight,
          ),
        );
      } else {
        if (!context.mounted) return;
        await showMessageDialog(
          context,
          MessageDialog(
            'Invalid QR Code',
            'The QR Code scanned is invalid! Please ensure that the QR code contains a valid DID.',
          ),
        );
      }
    }

    /// Handles the starting of VDSP listener
    void onVdspListenerChange(bool state) async {
      final vaultService = ref.read(vaultServiceProvider.notifier);
      if (state) {
        await vaultService.startVdspListener();
      } else {
        await vaultService.stopVdspListener();
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "VDSP Listener ${state ? 'enabled' : 'disabled'}",
            style: const TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: AppColorScheme.backgroundLight,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColorScheme.backgroundBlack,
      resizeToAvoidBottomInset: false,
      appBar: TdkAppBar(
        title: localizations.vaultSettingsPageHeader,
        showBackButton: true,
        onBackPressed: () => navigation.go(ProfilesRoutePath.base),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizing.paddingXLarge),
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
                    title: localizations.vdspListenerStateLabel(
                      listenerStatus != null && listenerStatus == true
                          ? 'Disable'
                          : 'Enable',
                    ),
                    onTap: () async {
                      final vdspListenerState = await showVdspListenerSettings(
                        context,
                        listenerStatus ?? false,
                      );

                      onVdspListenerChange(vdspListenerState);
                    },
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
      color: AppColorScheme.backgroundBlack,
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
