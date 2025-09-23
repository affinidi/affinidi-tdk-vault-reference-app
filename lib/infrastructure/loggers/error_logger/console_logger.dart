import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'error_logger.dart';

class ConsoleLogger implements ErrorLogger {
  final _logKey = 'ConsoleLogger';

  @override
  Future<void> ensureInitialized() async {
    log('ensureInitialized', name: _logKey);
  }

  @override
  void logError(Object error, StackTrace stack, {dynamic reason, Iterable<Object> information = const []}) {
    log('logError $error\n$stack', name: _logKey);
  }

  @override
  void logFatalError(Object error, StackTrace stack) {
    log('logFatalError $error\n$stack', name: _logKey);
  }

  @override
  void logFlutterFatalError(FlutterErrorDetails errorDetails) {
    log('logFlutterFatalError $errorDetails', name: _logKey);
  }
}
