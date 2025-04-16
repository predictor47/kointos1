import 'package:logging/logging.dart';

class LoggerService {
  static final Logger _logger = Logger('Kointos');
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;

    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      // In production, you might want to send logs to a service like Firebase Crashlytics
      // For development, we'll just print to console
      final message = '${record.level.name}: ${record.time}: ${record.message}';
      if (record.error != null) {
        print(
            '$message\nError: ${record.error}\nStack trace:\n${record.stackTrace}');
      } else {
        print(message);
      }
    });

    _initialized = true;
  }

  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.fine(message, error, stackTrace);
  }

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.info(message, error, stackTrace);
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.warning(message, error, stackTrace);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }
}
