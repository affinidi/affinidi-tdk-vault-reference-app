import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import '../../widgets/bottom_sheet_dialog.dart';

class ConsentHistoryDetailsSheet extends StatefulWidget {
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
                actions: [],
                onCancel: () => Navigator.of(sheetContext, rootNavigator: true)
                    .maybePop(),
                body: ConsentHistoryDetailsSheet(record: record),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  State<ConsentHistoryDetailsSheet> createState() =>
      _ConsentHistoryDetailsSheetState();
}

class _ConsentHistoryDetailsSheetState extends State<ConsentHistoryDetailsSheet> {
  late bool _rememberChoice;

  @override
  void initState() {
    super.initState();
    _rememberChoice = widget.record.isAutoShareEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final origin = _nullableText(
      widget.record.siteUrl,
      localizations.consentHistoryNotAvailable,
    );
    final profile = _nullableText(
      widget.record.profileName,
      localizations.consentHistoryNotAvailable,
    );
    final dataShared = _resolveDataShared(localizations.consentHistoryNotAvailable);
    final dateFormatted =
        _formatDate(widget.record.sharedAt, localizations.consentHistoryNotAvailable);
    final did = _resolveDid(localizations.consentHistoryNotAvailable);

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
        if (!widget.record.isConsentManagementEnabled) ...[
          const SizedBox(height: AppSizing.paddingSmall),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: AppSizing.iconXSmall,
                child: Checkbox(
                  visualDensity: VisualDensity.comfortable,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: _rememberChoice,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _rememberChoice = value;
                    });
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

  String _nullableText(String? value, String notAvailable) {
    if (value == null || value.trim().isEmpty) return notAvailable;
    return value.trim();
  }

  String _resolveDataShared(String notAvailable) {
    final data = widget.record.historySharedData;
    if (data.isEmpty) return notAvailable;

    final values = data.entries
        .map((entry) {
          final key = entry.key.trim();
          final value = entry.value.trim();
          if (key.isEmpty && value.isEmpty) return '';
          if (key.isEmpty) return value;
          if (value.isEmpty) return key;
          return '$key: $value';
        })
        .where((entry) => entry.isNotEmpty)
        .toList();

    if (values.isEmpty) return notAvailable;
    return values.join('\n');
  }

  String _resolveDid(String notAvailable) {
    final data = widget.record.historySharedData;
    for (final entry in data.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value.trim();
      if (key.contains('did') && value.isNotEmpty) return value;
      if (value.startsWith('did:')) return value;
    }
    return notAvailable;
  }

  String _formatDate(String isoDate, String notAvailable) {
    if (isoDate.isEmpty) return notAvailable;
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return DateFormat('MMM d, yyyy HH:mm').format(dt);
    } catch (_) {
      return notAvailable;
    }
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
