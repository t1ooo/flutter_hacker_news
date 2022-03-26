import 'package:flutter/foundation.dart';

import 'hacker_news_api.dart';
import 'item.dart';
import 'logging/logging.dart';
import 'result.dart';
import 'user.dart';

class CommentNotifier extends ChangeNotifier {
  CommentNotifier();

  final Map<int, bool> _visibilities = {};


  void toggleVisibility(int id) {
    _visibilities[id] = !isVisible(id);
    notifyListeners();
  }

  bool isVisible(int id) => _visibilities[id] ?? true;
}
