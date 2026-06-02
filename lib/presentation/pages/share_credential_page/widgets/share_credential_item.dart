import 'package:affinidi_tdk_claim_verifiable_credential/oid4vci_claim_verifiable_credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../infrastructure/extensions/veryfiable_credential_extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../pages/claimed_credential_details_page/claimed_credential_details_page.dart';
import '../../../themes/app_color_scheme.dart';
import '../../../themes/app_sizing.dart';

class ShareCredentialItem extends StatelessWidget {
  const ShareCredentialItem({
    super.key,
    required this.verifiableCredential,
    required this.isSelected,
    this.onChanged,
    this.onTap,
  });

  static const String _credentialIconAsset =
      'assets/icons/icons-navigation-verifiable-dark.svg';

  final VerifiableCredential verifiableCredential;
  final bool isSelected;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final displayName = verifiableCredential.displayName;
    final issuanceDate =
        verifiableCredential.formattedIssuanceDate(localizations.localeName);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColorScheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizing.paddingMedium),
        child: Row(
          children: [
            SvgPicture.asset(
              _credentialIconAsset,
              width: 28,
              height: 28,
            ),
            const SizedBox(width: AppSizing.paddingMedium),
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayName ?? localizations.verifiedData,
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizing.paddingXSmall),
                    Text(
                      '${localizations.issuanceDate}: $issuanceDate',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColorScheme.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSizing.paddingSmall),
            GestureDetector(
              onTap: () => ClaimedCredentialDetailsPage.show(
                context: context,
                verifiableCredential: verifiableCredential,
              ),
              child: const Icon(
                Icons.chevron_right,
                color: AppColorScheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
