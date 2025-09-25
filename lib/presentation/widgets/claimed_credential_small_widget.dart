import 'package:affinidi_tdk_claim_verifiable_credential/oid4vci_claim_verifiable_credential.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import '../../infrastructure/extensions/veryfiable_credential_extensions.dart';

class ClaimedCredentialSmallWidget extends StatelessWidget {
  const ClaimedCredentialSmallWidget(
      {super.key, required this.verifiableCredential});

  final VerifiableCredential verifiableCredential;

  @override
  Widget build(BuildContext context) {
    final displayName = verifiableCredential.displayName;
    final issuanceDate = verifiableCredential.formattedIssuanceDate('EN');
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: SvgPicture.asset(
            'assets/icons/icons-navigation-verifiable-dark.svg',
            width: 32,
            height: 32),
        title: Text(displayName ?? localizations.verifiedData),
        subtitle: Text('${localizations.issuanceDate} : $issuanceDate'),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
