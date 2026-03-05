import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../themes/app_sizing.dart';

enum VdspDialogChoice { cancel, ok }

/// Displays the dialog box that allows the user to accept or cancel incoming vdsp requests.
///
/// Returns:
/// - [VdspDialogChoice] - either ok or cancel
Future<VdspDialogChoice> showIncomingRequestDialog(BuildContext context) async {
  final localizations = AppLocalizations.of(context)!;

  final selected = await showDialog<VdspDialogChoice>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      insetPadding: const EdgeInsets.all(AppSizing.paddingRegular),
      title: Text(localizations.incomingVdspRequest),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localizations.verierRequestForCredential),
          SizedBox(height: AppSizing.paddingSmall),
          Text(localizations.allowVdspRequestQuestion),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(VdspDialogChoice.cancel),
          child: Text(localizations.cancelActionText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(VdspDialogChoice.ok),
          child: Text(localizations.confirmActionText),
        ),
      ],
    ),
  );

  return selected ?? VdspDialogChoice.cancel;
}

/// Displays the dialog box to inform the user that the qr scanning of the Verifier
/// is successful. It explicitly asks the user for consent to allow the verifier
/// to send messages to the user.
///
/// Returns:
/// - [VdspDialogChoice] - either ok or cancel
Future<VdspDialogChoice> showScanConfirmationDialog(
  BuildContext context,
  String verifierDid,
) async {
  final localizations = AppLocalizations.of(context)!;

  final selected = await showDialog<VdspDialogChoice>(
    context: context,
    builder: (ctx) => AlertDialog(
      insetPadding: const EdgeInsets.all(AppSizing.paddingRegular),
      title: const Text('QR Code Scan Successful'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Verifier DID: $verifierDid'),
          const SizedBox(height: AppSizing.paddingSmall),
          const Text(
            'Allow this verifier to request your credentials via VDSP?',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, VdspDialogChoice.cancel),
          child: Text(localizations.cancelActionText),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, VdspDialogChoice.ok),
          child: Text(localizations.confirmActionText),
        ),
      ],
    ),
  );

  return selected ?? VdspDialogChoice.cancel;
}

/// Displays the dialog box that the scanned QR code is invalid.
Future<void> showInvalidScannedQrCode(BuildContext context) async {
  final localizations = AppLocalizations.of(context)!;

  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      insetPadding: const EdgeInsets.all(AppSizing.paddingRegular),
      title: const Text('Scanned QR Code is invalid'),
      content: const Text('Please scan a valid QR Code.'),
      actions: [
        TextButton(
          onPressed: () async => Navigator.pop(ctx),
          child: Text(localizations.gotItActionText),
        ),
      ],
    ),
  );
}

/// Displays the alert dialog box stating that no credentials matched the DCQL
/// query sent by the Verifier.
Future<void> showNoMatchingCredentialsDialog(BuildContext context) async {
  final localizations = AppLocalizations.of(context)!;

  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      insetPadding: const EdgeInsets.all(AppSizing.paddingRegular),
      title: const Text('No Matching Credentials'),
      content: const Text(
        'The selected profile did not match any credentials.',
      ),
      actions: [
        TextButton(
          onPressed: () async => Navigator.pop(ctx),
          child: Text(localizations.gotItActionText),
        ),
      ],
    ),
  );
}

/// Displays the alert dialog box stating that profile selection for VDSP is
/// canceled by the user.
Future<void> showProfileSelectCanceledDialog(BuildContext context) async {
  final localizations = AppLocalizations.of(context)!;

  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      insetPadding: const EdgeInsets.all(AppSizing.paddingRegular),
      title: const Text('Profile Selection Canceled'),
      content: const Text(
        'You have canceled the profile selection. VDSP data sharing will not proceed.',
      ),
      actions: [
        TextButton(
          onPressed: () async => Navigator.pop(ctx),
          child: Text(localizations.gotItActionText),
        ),
      ],
    ),
  );
}
