import 'package:affinidi_tdk_claim_verifiable_credential/oid4vci_claim_verifiable_credential.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

import '../../widgets/bottom_sheet_dialog.dart';
import 'credential_tree_view.dart';

class ClaimedCredentialDetailsPage extends StatelessWidget {
  const ClaimedCredentialDetailsPage({
    super.key,
    required this.verifiableCredential,
  });

  final VerifiableCredential verifiableCredential;

  static Future<String?> show({
    required BuildContext context,
    required VerifiableCredential verifiableCredential,
  }) {
    final localizations = AppLocalizations.of(context)!;

    return showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => BottomSheetDialog(
        title: localizations.credentialDetails,
        actions: [],
        body: ClaimedCredentialDetailsPage(verifiableCredential: verifiableCredential),
        onCancel: () {
          if (!context.mounted) return;

          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CredentialTreeView(
      verifiableCredential: verifiableCredential,
    );
  }
}
