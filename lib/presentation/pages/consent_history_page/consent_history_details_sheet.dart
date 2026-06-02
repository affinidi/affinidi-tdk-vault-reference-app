import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import 'consent_history_page_controller.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/bottom_sheet_dialog.dart';

class ConsentHistoryDetailsSheet extends ConsumerWidget {
  const ConsentHistoryDetailsSheet({super.key, required this.record});

  final IotaConsentRecord record;

  static Future<void> show({
    required BuildContext context,
    required IotaConsentRecord record,
  }) {
    final localizations = AppLocalizations.of(context)!;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: surfaceColor,
      context: context,
      builder: (sheetContext) {
        final mediaQuery = MediaQuery.of(sheetContext);
        final topInset = mediaQuery.padding.top + kToolbarHeight;

        return Padding(
          padding: EdgeInsets.only(top: topInset),
          child: ColoredBox(
            color: surfaceColor,
            child: SizedBox.expand(
              child: BottomSheetDialog(
                title: localizations.consentHistoryDetails,
                actions: const [],
                onCancel: () =>
                    Navigator.of(sheetContext, rootNavigator: true).maybePop(),
                body: ConsentHistoryDetailsSheet(record: record),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final na = localizations.consentHistoryNotAvailable;
    final theme = Theme.of(context);
    final origin =
        ConsentHistoryPageController.formatDisplayText(record.siteUrl, na);
    final profile =
        ConsentHistoryPageController.formatDisplayText(record.profileName, na);
    final dataShared =
        ConsentHistoryPageController.formatDataShared(record, na);
    final dateFormatted =
        ConsentHistoryPageController.formatDate(record.sharedAt, na);
    final did = ConsentHistoryPageController.formatDid(record, na);
    final isAutoShareEnabled = ref.watch(
      consentHistoryPageControllerProvider.select(
        (state) => state.records
            .firstWhere(
              (storedRecord) => storedRecord.hash == record.hash,
              orElse: () => record,
            )
            .isAutoShareEnabled,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DetailPair(
          label: localizations.consentHistoryWebsiteLabel,
          value: origin,
          theme: theme,
        ),
        _DetailPair(
          label: localizations.consentHistoryProfileLabel,
          value: profile,
          theme: theme,
        ),
        _DetailPair(
          label: localizations.consentHistoryDataSharedLabel,
          value: dataShared,
          theme: theme,
        ),
        _DetailPair(
          label: localizations.consentHistoryLastConsentedLabel,
          value: dateFormatted,
          theme: theme,
        ),
        _DetailPair(
          label: localizations.consentHistoryDidLabel,
          value: did,
          theme: theme,
        ),
        if (!record.isConsentManagementEnabled) ...[
          const SizedBox(height: AppSizing.paddingSmall),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: AppSizing.iconXSmall,
                child: Checkbox(
                  visualDensity: VisualDensity.comfortable,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: isAutoShareEnabled,
                  onChanged: (value) {
                    if (value == null) return;
                    ref
                        .read(consentHistoryPageControllerProvider.notifier)
                        .setAutoShareEnabled(record.hash, value);
                  },
                ),
              ),
              const SizedBox(width: AppSizing.paddingSmall),
              Expanded(
                child: Text(
                  localizations.consentHistoryRememberMyChoice,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColorScheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _DetailPair extends StatelessWidget {
  const _DetailPair({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizing.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColorScheme.textSecondary,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSizing.paddingXSmall),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColorScheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
