import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  static void info(String message, {String? tag}) {
    _log('INFO', message, tag: tag);
  }

  static void error(String message, {dynamic error, StackTrace? stackTrace, String? tag}) {
    _log('ERROR', message, error: error, stackTrace: stackTrace, tag: tag);
  }

  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      _log('DEBUG', message, tag: tag);
    }
  }

  static void _log(String level, String message, {dynamic error, StackTrace? stackTrace, String? tag}) {
    final logTag = tag != null ? '[$tag]' : '[App]';
    final timestamp = DateTime.now().toIso8601String().split('T').last.split('.').first;
    
    String color;
    switch (level) {
      case 'ERROR':
        color = '\x1B[31m'; // Red
        break;
      case 'DEBUG':
        color = '\x1B[33m'; // Yellow
        break;
      case 'INFO':
        color = '\x1B[32m'; // Green
        break;
      default:
        color = '\x1B[0m';  // Reset
    }

    final reset = '\x1B[0m';
    final formattedMessage = '$color$timestamp $level $logTag: $message$reset';
    
    if (level == 'ERROR') {
      developer.log(formattedMessage, error: error, stackTrace: stackTrace, name: 'RideIQ');
    } else {
      developer.log(formattedMessage, name: 'RideIQ');
    }
    
    debugPrint(formattedMessage);
  }

}
