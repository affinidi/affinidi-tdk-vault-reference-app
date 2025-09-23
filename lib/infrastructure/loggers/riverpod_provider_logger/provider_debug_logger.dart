import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProviderDebugLogger extends ProviderObserver {
  @override
  void didAddProvider(ProviderBase provider, Object? value, ProviderContainer container) {
    log(name: 'Provider', 'Add: "${provider.name ?? provider.runtimeType}"');
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    log(name: 'Provider', 'Dispose: "${provider.name ?? provider.runtimeType}"');
  }
}
