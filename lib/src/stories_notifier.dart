import 'package:flutter/foundation.dart';

import 'hacker_news_api.dart';
import 'item.dart';
import 'logging/logging.dart';
import 'user.dart';

class StoriesNotifier extends ChangeNotifier {
  StoriesNotifier(this.api);

  final HackerNewsApi api;
  static final _log = Logger('StoriesNotifier');
  final int delay = 1;

  Future<List<int>> stories(StoryType storyType, int limit, int offset) {
    return Future.delayed(Duration(seconds: delay), () async {
      return (await api.stories(storyType)).skip(offset).take(limit).toList();
    });
  }
}
