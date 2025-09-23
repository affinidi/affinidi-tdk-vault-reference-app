import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../l10n/app_localizations.dart';

class PaginationControls extends ConsumerWidget {
  const PaginationControls({
    super.key,
    required this.isLoading,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.currentPageIndex,
    required this.lastEvaluatedItemIdStack,
    required String profileId,
  });

  final bool isLoading;
  final int currentPageIndex;
  final List<String?> lastEvaluatedItemIdStack;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final isFirstPage = currentPageIndex == 0;
    final isLastPage =
        lastEvaluatedItemIdStack.length <= currentPageIndex || lastEvaluatedItemIdStack[currentPageIndex] == null;

    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: localizations.paginationPreviousPage,
          icon: Icon(Icons.arrow_back),
          disabledColor: Theme.of(context).disabledColor,
          onPressed: isFirstPage ? null : onPreviousPage,
        ),
        Text(localizations.paginationPageLabel(currentPageIndex + 1)),
        IconButton(
          tooltip: localizations.paginationNextPage,
          disabledColor: Theme.of(context).disabledColor,
          icon: Icon(Icons.arrow_forward),
          onPressed: isLastPage ? null : onNextPage,
        ),
      ],
    );
  }
}
