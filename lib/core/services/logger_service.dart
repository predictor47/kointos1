import 'package:logger/logger.dart';

class LoggerService {
  static late Logger _logger;
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;

    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );

    _initialized = true;
  }

  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (!_initialized) init();
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    if (!_initialized) init();
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (!_initialized) init();
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (!_initialized) init();
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
