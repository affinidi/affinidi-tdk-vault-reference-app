import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import 'consent_history_details_sheet.dart';
import 'consent_history_logo_avatar.dart';

class ConsentHistoryItem extends StatelessWidget {
  const ConsentHistoryItem({super.key, required this.record});

  final IotaConsentRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final siteUrl = record.siteUrl;
    final origin = (siteUrl != null && siteUrl.trim().isNotEmpty)
        ? siteUrl.trim()
        : localizations.consentHistoryNotAvailable;
    final dateFormatted =
        _formatDate(record.sharedAt, localizations.consentHistoryNotAvailable);

    return InkWell(
      onTap: () =>
          ConsentHistoryDetailsSheet.show(context: context, record: record),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizing.paddingMedium,
          vertical: AppSizing.paddingRegular,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConsentHistoryLogoAvatar(logoUrl: record.logo),
            const SizedBox(width: AppSizing.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    origin,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColorScheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    record.profileName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColorScheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateFormatted,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColorScheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_horiz,
                  color: AppColorScheme.textSecondary),
              onPressed: () => ConsentHistoryDetailsSheet.show(
                  context: context, record: record),
              tooltip: 'Details',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String isoDate, String notAvailable) {
    if (isoDate.isEmpty) return notAvailable;
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return DateFormat('MMM d, yyyy').format(dt);
    } catch (_) {
      return notAvailable;
    }
  }
}
