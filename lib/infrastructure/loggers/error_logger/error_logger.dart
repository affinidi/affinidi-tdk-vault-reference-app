import 'package:flutter/foundation.dart';

abstract class ErrorLogger {
  Future<void> ensureInitialized();
  void logError(Object error, StackTrace stack, {dynamic reason, Iterable<Object> information});
  void logFatalError(Object error, StackTrace stack);
  void logFlutterFatalError(FlutterErrorDetails errorDetails);
}
