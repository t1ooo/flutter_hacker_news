import 'package:flutter/foundation.dart';

import 'hacker_news_api.dart';
import 'item.dart';
import 'logging/logging.dart';
import 'result.dart';
import 'user.dart';

typedef ItemResult = Result<Item, Object>;

class ItemNotifier extends ChangeNotifier {
  ItemNotifier(this.api);

  final HackerNewsApi api;
  static final _log = Logger('ItemNotifier');
  final int delay = 1;

  // Future<List<int>> stories(StoryType storyType, int limit, int offset) {
  //   return Future.delayed(Duration(seconds: delay), () async {
  //     return (await api.stories(storyType)).skip(offset).take(limit).toList();
  //   });
  // }

  final Map<int, ItemResult> _items = {};
  // Map<int, ItemResult> get items => _items;

  ItemResult item(int id) {
    return _items[id] ?? ItemResult.empty();
  }

  Future<void> loadItem(int id) async {
    // print('load: $id');
    _items[id] = await Future.delayed(Duration(seconds: delay), () async {
      try {
        final item = await api.item(id);
        return ItemResult.value(item);
      } on Exception catch (e, st) {
        _log.error(e, st);
        return ItemResult.error(e);
      }
    });
    notifyListeners();
  }
}
