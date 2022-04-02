import 'package:flutter/foundation.dart';

import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/item.dart';
import '../logging/logging.dart';
import 'change_notifier.dart';
import 'result.dart';

typedef ItemResult = Result<Item, Object>;

class ItemNotifier extends ChangeNotifier with TryNotifyListeners {
  ItemNotifier(this.api);

  final HackerNewsApi api;
  final Map<int, ItemResult> _items = {};
  static final _log = Logger('ItemNotifier');

  ItemResult item(int id) {
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

  Future<void> reloadItems({bool awaited = false}) async {
    _log.info('reloadItems');
    for (final id in _items.keys) {
      _items[id] = ItemResult.empty();
      if (awaited) {
        await reloadItem(id);
      } else {
        // ignore: unawaited_futures
        reloadItem(id);
      }
    }
  }

  Future<void> _loadItem(int id, bool cached) async {
    try {
      final item = await api.item(id, cached: cached);
      _items[id] = ItemResult.value(item);
    } on Exception catch (e, st) {
      _log.error(e, st);
      _items[id] = ItemResult.error(e);
    }

    tryNotifyListeners();
  }
}
