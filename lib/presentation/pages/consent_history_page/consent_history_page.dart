import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import 'consent_history_page_controller.dart';

class ConsentHistoryPage extends ConsumerWidget {
  const ConsentHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(consentHistoryPageControllerProvider);
    final localizations = AppLocalizations.of(context)!;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizing.paddingLarge),
          child: Text(
            localizations.consentHistoryTitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColorScheme.textSecondary,
                ),
          ),
        ),
      ),
    );
  }
}
