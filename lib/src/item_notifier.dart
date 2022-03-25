import 'package:flutter/foundation.dart';

import 'hacker_news_api.dart';
import 'item.dart';
import 'logging/logging.dart';
import 'user.dart';

class ItemNotifier extends ChangeNotifier {
  ItemNotifier(this.api);

  // final HackerNewsApi api;
  // static final _log = Logger('ItemNotifier');
  // final int delay = 1;

  // Future<List<int>> stories(StoryType storyType, int limit, int offset) {
  //   return Future.delayed(Duration(seconds: delay), () async {
  //     return (await api.stories(storyType)).skip(offset).take(limit).toList();
  //   });
  // }

  Map<int, List<int>> _items = {};
  Map<int, List<int>> get items => _items;

  Future<void> item(int id) async {
    // print('load: $id');
    _items[id] = Future.delayed(Duration(seconds: delay), () => api.item(id));
    notifyListeners();
  }
}
