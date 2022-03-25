import 'package:flutter/foundation.dart';

import 'hacker_news_api.dart';
import 'item.dart';
import 'logging/logging.dart';
import 'result.dart';
import 'user.dart';

typedef StoryIdsResult = Result<List<int>, Object>;

class StoriesNotifier extends ChangeNotifier {
  StoriesNotifier(this.api);

  final HackerNewsApi api;
  static final _log = Logger('StoriesNotifier');
  final int delay = 1;

  StoryIdsResult _storyIds = StoryIdsResult.empty();
  StoryIdsResult get storyIds => _storyIds;

  Future<void> loadStoryIds(StoryType storyType, int limit, int offset) async {
    _storyIds = await Future.delayed(Duration(seconds: delay), () async {
      try {
        final ids = (await api.stories(storyType)).skip(offset).take(limit).toList();
        return StoryIdsResult.value(ids);
      } on Exception catch (e, st) {
        _log.error(e, st);
        return StoryIdsResult.error(e);
      }
    });
  }
}


// class StoriesNotifierV2 extends ChangeNotifier  with E {
//   StoriesNotifierV2(this.api);

//   final HackerNewsApi api;
//   static final _log = Logger('StoriesNotifier');
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
