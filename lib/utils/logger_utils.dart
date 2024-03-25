import 'package:logger/logger.dart';

class JLogger {
  Logger logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  void infoLog(message) {
    logger.i("Info log: $message", time: DateTime.timestamp().toLocal());
  }

  void errorLog(message, dynamic e) {
    logger.e("Error log: $message",
        error: e, time: DateTime.timestamp().toLocal());
  }

  void warningLog(message) {
    logger.w("Warning log: $message", time: DateTime.timestamp().toLocal());
  }

  void debugLog(message) {
    logger.d("Debug log: $message", time: DateTime.timestamp().toLocal());
  }
}
