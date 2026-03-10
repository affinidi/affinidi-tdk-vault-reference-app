import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../themes/app_sizing.dart';
import '../profile/did_display.dart';
import '../qrcode_view.dart';

class MessageDialog {
  MessageDialog(this._title, this._content);

  final String? _title;
  final String? _content;

  String get title => _title!;
  String get content => _content!;
}

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

/// A reusable function which displays a message dialog box.
Future<void> showMessageDialog(
  BuildContext context,
  MessageDialog message,
) async {
  final localizations = AppLocalizations.of(context)!;

  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      insetPadding: const EdgeInsets.all(AppSizing.paddingRegular),
      title: Text(message.title),
      content: Text(message.content),
      actions: [
        TextButton(
          onPressed: () async => Navigator.pop(ctx),
          child: Text(localizations.gotItActionText),
        ),
      ],
    ),
  );
}

void showMessagingDidDialog(BuildContext context, String messagingDid) {
  showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      child: Container(
        padding: const EdgeInsets.all(AppSizing.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            QrCodeView(content: messagingDid),
            DidDisplay(did: messagingDid),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    ),
  );
}
