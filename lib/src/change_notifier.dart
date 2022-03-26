import 'package:flutter/foundation.dart';

/* class SafeChangeNotifier extends ChangeNotifier {
  bool _disposed = false;

  void safeNotifyListeners() {
    if (_disposed) {
      return;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
} */


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
