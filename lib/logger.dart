import 'dart:async';

import 'src/logging/logging.dart';

StreamSubscription<LogRecord>? _loggerSub;

// ignore: avoid_positional_boolean_parameters
void configureLogger(bool debugMode) {
  if (!debugMode) {
    return;
  }
  if (_loggerSub != null) {
    return;
  }
  Logger.root.level = Level.ALL;
  _loggerSub = Logger.root.onRecord.listen((LogRecord record) {
    // ignore: avoid_print
    print(
      '${record.level.name}: '
      '${record.time}: '
      '${record.loggerName}: '
      '${record.message} '
      '${record.error != null ? '${record.error} ' : ''}'
      '${record.stackTrace != null ? '${record.stackTrace}' : ''}',
    );
  });
}
