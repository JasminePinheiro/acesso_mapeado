import 'dart:developer' as developer;

class Logger {
  static void logError(String message) {
    developer.log(message, name: 'ERROR');
  }

  static void logInfo(String message) {
    developer.log(message, name: 'INFO');
  }
}
