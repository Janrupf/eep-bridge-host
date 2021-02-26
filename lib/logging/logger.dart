import 'package:logger/logger.dart' as backend;

class Logger {
  static backend.Logger _instance = backend.Logger(
      level: backend.Level.verbose,
      printer: backend.PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 100,
          printEmojis: false,
          printTime: true,
          colors: true));

  static void verbose(dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    _instance.v(message, error, stackTrace);
  }

  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance.d(message, error, stackTrace);
  }

  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance.i(message, error, stackTrace);
  }

  static void warn(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance.w(message, error, stackTrace);
  }

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance.e(message, error, stackTrace);
  }

  static void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance.wtf(message, error, stackTrace);
  }
}
