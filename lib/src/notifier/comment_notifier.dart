import 'package:flutter/foundation.dart';

class CommentNotifier extends ChangeNotifier {
  CommentNotifier();

  final Map<int, bool> _visibilities = {};

  void toggleVisibility(int id) {
    _visibilities[id] = !isVisible(id);
    notifyListeners();
  }

  bool isVisible(int id) => _visibilities[id] ?? true;
}
