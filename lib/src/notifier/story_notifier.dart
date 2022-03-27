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
  static final _log = Logger('StoryNotifier');
  final int delay = 1;

  StoryIdsResult _storyIds = StoryIdsResult.empty();
  StoryIdsResult get storyIds => _storyIds;

  Future<void> loadStoryIds(StoryType storyType) async {
    return _loadStoryIds(storyType, true);
  }

  Future<void> reloadStoryIds(StoryType storyType) async {
    return _loadStoryIds(storyType, false);
  }

  Future<void> _loadStoryIds(StoryType storyType, bool cached) async {
    _log.info('loadStoryIds: $storyType');
    _storyIds = await Future.delayed(Duration(seconds: delay), () async {
      try {
        // final ids = (await api.stories(storyType)).skip(offset).take(limit).toList();
        final ids = await api.stories(storyType, cached);
        return StoryIdsResult.value(ids);
      } on Exception catch (e, st) {
        _log.error(e, st);
        return StoryIdsResult.error(e);
      }
    });
    tryNotifyListeners();
  }
}


// class StoryNotifierV2 extends ChangeNotifier  with E {
//   StoryNotifierV2(this.api);

//   final HackerNewsApi api;
//   static final _log = Logger('StoryNotifier');
//   final int delay = 1;

//   StoryIdsResult _storyIds = StoryIdsResult.empty();
//   StoryIdsResult get storyIds => _storyIds;

//   Future<void> loadStoryIds(StoryType storyType, int limit, int offset) async {
//     _storyIds = await getStoryIds(storyType, limit, offset);
//   }
// }

// mixin E {
//   late final HackerNewsApi api;
//   static late Logger _log;
//   final int delay = 1;

//   Future<StoryIdsResult> getStoryIds(StoryType storyType, int limit, int offset) async {
//     return await Future.delayed(Duration(seconds: delay), () async {
//       try {
//         final ids = (await api.stories(storyType)).skip(offset).take(limit).toList();
//         return StoryIdsResult.value(ids);
//       } on Exception catch (e, st) {
//         _log.error(e, st);
//         return StoryIdsResult.error(e);
//       }
//     });
//   }
// }
