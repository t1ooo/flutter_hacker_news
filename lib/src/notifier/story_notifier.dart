import 'package:flutter/foundation.dart';

import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/story_type.dart';
import '../logging/logging.dart';
import 'change_notifier.dart';
import 'result.dart';

typedef StoryIdsResult = Result<List<int>, Object>;

class StoryNotifier extends ChangeNotifier with TryNotifyListeners {
  StoryNotifier(this.api);

  final HackerNewsApi api;
  StoryIdsResult? _storyIds;
  StoryIdsResult get storyIds => _storyIds ?? StoryIdsResult.empty();
  static final _log = Logger('StoryNotifier');

  Future<void> loadStoryIds(StoryType storyType) async {
    if (_storyIds == null) {
      return _loadStoryIds(storyType, true);
    }
  }

  Future<void> reloadStoryIds(StoryType storyType) async {
    return _loadStoryIds(storyType, false);
  }

  Future<void> _loadStoryIds(StoryType storyType, bool cached) async {
    _log.info('loadStoryIds: $storyType');
    try {
      final ids = await api.stories(storyType, cached);
      _storyIds = StoryIdsResult.value(ids);
    } on Exception catch (e, st) {
      _log.error(e, st);
      _storyIds = StoryIdsResult.error(e);
    }

    tryNotifyListeners();
  }
}
