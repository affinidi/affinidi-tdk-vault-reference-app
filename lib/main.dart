import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../l10n/app_localizations.dart';
import 'infrastructure/utils/constants.dart';

import 'infrastructure/loggers/error_logger/error_logging_handler.dart';
import 'infrastructure/loggers/riverpod_provider_logger/provider_debug_logger.dart';
import 'navigation/navigation_provider.dart';
import 'presentation/themes/app_theme.dart';
import 'infrastructure/db/app_database.dart';

class AppLifecycleReactor extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      AppDatabase().closeDb();
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('EN_US_POSIX');

  ErrorLoggingHandler.instance.ensureInitialized();

  // Register the lifecycle observer
  WidgetsBinding.instance.addObserver(AppLifecycleReactor());

  runApp(
    ProviderScope(observers: [
      if (kDebugMode) ProviderDebugLogger(),
    ], child: const MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final routerConfig = ref.watch(navigationProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      localizationsDelegates: [
        AppLocalizations.delegate,
      ],
      theme: AppTheme.main,
      routerConfig: routerConfig,
    );
  }
}
