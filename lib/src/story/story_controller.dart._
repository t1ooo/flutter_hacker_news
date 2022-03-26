import 'package:flutter/foundation.dart';

import '../hacker_news_api.dart';
import '../item.dart';
import '../logging/logging.dart';
import '../result.dart';

typedef StoryIdsResult = Result<List<int>, Object>;
typedef ItemResult = Result<Item, Object>;

class StoryController extends ChangeNotifier {
  StoryController(this.api);

  final HackerNewsApi api;
  static final _log = Logger('StoryController');
  final int delay = 1;

  ItemResult _story = ItemResult.empty();
  final Map<int, ItemResult> _comments = {};
  final Map<int, bool> _commentVisibility = {};

  ItemResult get story => _story;

  ItemResult comment(int id) => _comments[id] ?? ItemResult.empty();

  Future<void> loadStory(int id) async {
    _story = await _loadItem(id);
    notifyListeners();
  }

  Future<void> loadComment(int id) async {
    _comments[id] = await _loadItem(id);
    notifyListeners();
  }

  void toggleCommentVisibility(int id) {
    _commentVisibility[id] = !isCommentVisible(id);
    notifyListeners();
  }

  bool isCommentVisible(int id) => _commentVisibility[id] ?? true;

  Future<ItemResult> _loadItem(int id) async {
    // print('load: $id');
    return await Future.delayed(Duration(seconds: delay), () async {
      try {
        final item = await api.item(id);
        return ItemResult.value(item);
      } on Exception catch (e, st) {
        _log.error(e, st);
        return ItemResult.error(e);
      }
    });
  }
}
