import 'package:flutter/foundation.dart';
import 'package:flutter_hacker_news_prototype/src/logging/logging.dart';
import 'package:flutter_hacker_news_prototype/src/notifier/result.dart';

import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/item.dart';
import 'change_notifier.dart';

typedef ItemResult = Result<Item, Object>;

class ItemNotifier extends ChangeNotifier with TryNotifyListeners {
  ItemNotifier(this.api);

  final HackerNewsApi api;
  final Map<int, ItemResult> _items = {};
  static final _log = Logger('ItemNotifier');

  ItemResult item(int id) {
    // _log.info('item: $id');
    return _items[id] ?? ItemResult.empty();
  }

  Future<void> loadItem(int id) async {
    if (!_items.containsKey(id)) {
      return _loadItem(id, true);
    }
  }

  Future<void> reloadItem(int id) async {
    return _loadItem(id, false);
  }

  Future<void> reloadItems() async {
    for (final id in _items.keys) {
      _items[id] = ItemResult.empty();
      reloadItem(id);
    }
  }

  Future<void> _loadItem(int id, bool cached) async {
    // tryNotifyListeners();
    try {
      final item = await api.item(id, cached);
      _items[id] = ItemResult.value(item);
    } on Exception catch (e, st) {
      _log.error(e, st);
      _items[id] = ItemResult.error(e);
    }
    tryNotifyListeners();
  }
}
