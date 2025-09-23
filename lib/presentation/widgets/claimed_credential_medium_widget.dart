import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/extensions/veryfiable_credential_extensions.dart';
import '../themes/app_sizing.dart';

class ClaimedCredentialMediumWidget extends ConsumerWidget {
  const ClaimedCredentialMediumWidget({
    super.key,
    required this.digitalCredential,
    required this.onShowOptions,
  });

  final DigitalCredential digitalCredential;
  final void Function(DigitalCredential digitalCredential) onShowOptions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final localName = localizations.localeName;
    final credential = digitalCredential.verifiableCredential;
    final displayName = credential.displayName;
    final expiryDate = credential.formattedExpiryDate(localName) ?? localizations.neverExpires;
    final issuanceDate = credential.formattedIssuanceDate(localName);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            AppSizing.paddingMedium, AppSizing.paddingXSmall, AppSizing.paddingMedium, AppSizing.paddingMedium),
        child: Column(
          spacing: AppSizing.paddingSmall,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SvgPicture.asset('assets/icons/icons-navigation-verifiable-dark.svg',
                  width: AppSizing.iconLarge, height: AppSizing.iconLarge),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => onShowOptions(digitalCredential),
                    icon: Icon(CupertinoIcons.ellipsis),
                  ),
                ],
              ),
            ),
            Text(localizations.verifiedCredentials,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            if (displayName != null)
              Text(displayName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800)),
            Text(
              digitalCredential.verifiableCredential.issuer.id.toString(),
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSizing.paddingXSmall,
                    children: [
                      Text(localizations.issuanceDate, style: theme.textTheme.bodySmall),
                      Text(issuanceDate.toString(), style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: AppSizing.paddingXSmall,
                    children: [
                      Text(localizations.expiryDate, style: theme.textTheme.bodySmall),
                      Text(expiryDate.toString(), style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
