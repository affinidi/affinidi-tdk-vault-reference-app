import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../themes/app_color_scheme.dart';
import '../../themes/app_sizing.dart';
import 'consent_history_item.dart';
import 'consent_history_page_controller.dart';

class ConsentHistoryPage extends ConsumerWidget {
  const ConsentHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      consentHistoryPageControllerProvider.select((state) => state.isLoading),
    );
    final error = ref.watch(
      consentHistoryPageControllerProvider.select((state) => state.error),
    );
    final records = ref.watch(
      consentHistoryPageControllerProvider.select((state) => state.records),
    );
    final controller = ref.read(consentHistoryPageControllerProvider.notifier);
    final localizations = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizing.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColorScheme.error, size: AppSizing.iconXLarge),
              const SizedBox(height: AppSizing.paddingMedium),
              Text(
                error,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColorScheme.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizing.paddingMedium),
              TextButton(
                onPressed: controller.refresh,
                child: Text(localizations.retryActionText),
              ),
            ],
          ),
        ),
      );
    }

    if (records.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizing.paddingLarge),
          child: Text(
            localizations.consentHistoryEmpty,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColorScheme.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: AppSizing.paddingSmall),
        itemCount: records.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: AppColorScheme.divider,
        ),
        itemBuilder: (context, index) =>
            ConsentHistoryItem(record: records[index]),
      ),
    );
  }
}
