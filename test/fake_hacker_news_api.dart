import 'package:flutter_hacker_news_prototype/src/clock/clock.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/hacker_news_api.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/item.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/story_type.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/user.dart';
import 'package:flutter_hacker_news_prototype/src/util/data_time.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeHackerNewsApi implements HackerNewsApi {
  FakeHackerNewsApi([this.clock = const Clock()]);

  final Clock clock;
  final _delay = Duration(milliseconds: 200);

  int _time(bool cached) =>
      cached ? 0 : unixTimeFromDateTime(clock.now()); // secondsSinceEpoch

  @override
  Future<Item> item(int id, {bool cached = true}) async {
    await Future.delayed(_delay);
    return Item(
      id: id,
      deleted: false,
      type: 'story',
      by: 'user-name',
      time: _time(cached),
      dead: false,
      parent: 0,
      poll: 0,
      kids: id < 5 ? [id + 1, id + 2, id + 3] : [],
      url: 'https://example.com',
      score: 0,
      title: 'item-title',
      parts: 0,
      descendants: 0,
    );
  }

  @override
  Future<User> user(String name, {bool cached = true}) async {
    await Future.delayed(_delay);
    return User(
      id: 'user-name',
      created: 0,
      karma: 0,
      about: 'user-about',
      submitted: const [0, 1, 2, 3, 4, 5],
    );
  }

  @override
  Future<List<int>> stories(StoryType storyType, {bool cached = true}) async {
    await Future.delayed(_delay);
    return [1, 2, 3, 4, 5];
  }
}
