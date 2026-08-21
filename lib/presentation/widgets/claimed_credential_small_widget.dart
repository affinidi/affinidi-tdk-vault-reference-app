import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ssi/ssi.dart' show VerifiableCredential;

import '../../../l10n/app_localizations.dart';
import '../../infrastructure/extensions/verifiable_credential_extensions.dart';

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
