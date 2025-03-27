import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:work_order_app/core/utils/debug_log.dart';

class AppConfig {
  static final String environment = dotenv.env['ENVIRONMENT'] ?? 'development';
  static final String backendDomain = dotenv.env['BACKEND_DOMAIN']!;

  static Map<String, dynamic> toMap() {
    return {
      'environment': environment
    };
  }

  static String toJson() {
    return jsonEncode(toMap());
  }

  static void logConfig() {
    DebugLog.info(message: "AppConfig: ${toJson()}");
  }
}