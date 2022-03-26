import 'package:flutter/foundation.dart';

import '../hacker_news_api.dart';
import '../item.dart';
import '../logging/logging.dart';
import '../result.dart';

typedef StoryIdsResult = Result<List<int>, Object>;
typedef ItemResult = Result<Item, Object>;

class StoriesController extends ChangeNotifier {
  StoriesController(this.api);

  final HackerNewsApi api;
  static final _log = Logger('StoriesController');
  final int delay = 1;

  StoryIdsResult _storyIds = StoryIdsResult.empty();
  StoryIdsResult get storyIds => _storyIds;

  // Future<void> loadStoryIds(StoryType storyType, int limit, int offset) async {
  Future<void> loadStoryIds(StoryType storyType) async {
    _storyIds = await Future.delayed(Duration(seconds: delay), () async {
      try {
        final ids =
            // (await api.stories(storyType)).skip(offset).take(limit).toList();
            await api.stories(storyType);
        return StoryIdsResult.value(ids);
      } on Exception catch (e, st) {
        _log.error(e, st);
        return StoryIdsResult.error('fail to load');
      }
    });
    notifyListeners();
  }

  final Map<int, ItemResult> _items = {};
  ItemResult item(int id) => _items[id] ?? ItemResult.empty();


  // TODO: return story instead item
  // Story.fromItem(Item)
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
