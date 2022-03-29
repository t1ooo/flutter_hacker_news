import 'package:flutter/foundation.dart';

mixin TryNotifyListeners on ChangeNotifier {
  bool _disposed = false;

  bool tryNotifyListeners() {
    if (_disposed) {
      return false;
    }

    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
