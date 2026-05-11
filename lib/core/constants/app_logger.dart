import 'package:logger/logger.dart';

class AppLogger {
  static void info(String message) {
    Logger().i(message);
  }
  static void warning(String message) {
    Logger().w(message);
  }
  static void error(String message) {
    Logger().e(message);
  }
  static void debug(String message) {
    Logger().d(message);
  }
  static void fatal(String message) {
    Logger().f(message);
  }

}
