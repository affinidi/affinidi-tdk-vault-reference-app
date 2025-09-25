import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stack_trace/stack_trace.dart';

import 'console_logger.dart';
import 'error_logger.dart';

class ErrorLoggingHandler {
  ErrorLoggingHandler._();

  @visibleForTesting
  ErrorLoggingHandler();

  static final ErrorLoggingHandler _instance = ErrorLoggingHandler._();

  static final ErrorLoggingHandler instance = _instance;

  List<ErrorLogger> loggers = [
    if (kDebugMode) ConsoleLogger(),
  ];

  void logError(
    error,
    stack, {
    dynamic reason,
    Iterable<Object> information = const [],
  }) {
    for (final logger in loggers) {
      logger.logError(error, stack, reason: reason, information: information);
    }
  }

  Future<void> ensureInitialized() async {
    await Future.wait(loggers.map((logger) => logger.ensureInitialized()));

    FlutterError.demangleStackTrace = (StackTrace stack) {
      if (stack is Trace) {
        return stack.vmTrace;
      }
      if (stack is Chain) {
        return stack.toTrace().vmTrace;
      }
      return stack;
    };

    FlutterError.onError = (errorDetails) {
      for (final logger in loggers) {
        logger.logFlutterFatalError(errorDetails);
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      for (final logger in loggers) {
        logger.logFatalError(error, stack);
      }
      return true;
    };
  }
}

AutoDisposeProvider<ErrorLoggingHandler> errorLoggingProvider =
    Provider.autoDispose<ErrorLoggingHandler>((ref) {
  return ErrorLoggingHandler.instance;
}, name: 'errorLoggingProvider');
