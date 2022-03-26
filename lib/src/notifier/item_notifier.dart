import 'package:flutter/foundation.dart';
import 'package:flutter_hacker_news_prototype/src/logging/logging.dart';
import 'package:flutter_hacker_news_prototype/src/notifier/result.dart';
import 'package:logging/logging.dart';

import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/item.dart';
import 'change_notifier.dart';


typedef ItemResult = Result<Item, Object>;

class ItemNotifier extends ChangeNotifier with TryNotifyListeners{
  ItemNotifier(this.api);

  final HackerNewsApi api;
  static final _log = Logger('ItemNotifier');
  final int delay = 1;
  bool _disposed = false;

  // Future<List<int>> stories(StoryType storyType, int limit, int offset) {
  //   return Future.delayed(Duration(seconds: delay), () async {
  //     return (await api.stories(storyType)).skip(offset).take(limit).toList();
  //   });
  // }

  final Map<int, ItemResult> _items = {};
  // Map<int, ItemResult> get items => _items;
  // final Map<int, bool> _visibilities = {};

  ItemResult item(int id) {
    _log.info('item: $id');
    return _items[id] ?? ItemResult.empty();
  }

  // void toggleVisibility(int id) {
  //   _visibilities[id] = !isVisible(id);
  //   notifyListeners();
  // }

  // bool isVisible(int id) => _visibilities[id] ?? true;

  Future<void> loadItem(int id) async {
    _items[id] = await Future.delayed(Duration(seconds: delay), () async {
      try {
        final item = await api.item(id);
        return ItemResult.value(item);
      } on Exception catch (e, st) {
        _log.error(e, st);
        return ItemResult.error(e);
      }
    });

    tryNotifyListeners();
    // safeNotifyListeners();
  }

  // void safeNotifyListeners() {
  //   if (_disposed) {
  //     return;
  //   }
  //   notifyListeners();
  // }

  // @override
  // void dispose() {
  //   _disposed = true;
  //   super.dispose();
  // }
}
