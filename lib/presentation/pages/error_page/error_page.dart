import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../themes/app_sizing.dart';

class ErrorPage extends StatelessWidget {
  final Exception? error;
  final VoidCallback? onRetry;

  const ErrorPage({
    super.key,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.error)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error?.toString() ?? localizations.unknownError),
            const SizedBox(height: AppSizing.paddingMedium),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(localizations.back),
            ),
          ],
        ),
      ),
    );
  }
}
