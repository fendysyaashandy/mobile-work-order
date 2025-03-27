import 'package:flutter/foundation.dart';

class DebugLog {
  static void info({required String message}) {
    debugPrint('\x1B[35mINFO: $message\x1B[0m');
  }

  static void error({required String message, StackTrace? stackTrace}) {
    debugPrint(
        '\x1B[31mERROR: $message, ${stackTrace != null ? 'stackTrace: $stackTrace' : ''}\x1B[0m');
  }

  static void warning({required String message}) {
    debugPrint('\x1B[33mWARNING: $message\x1B[0m');
  }

  static void checkMode(Function debugFunction) {
    if (kDebugMode) {
      debugFunction();
    }
  }
}
