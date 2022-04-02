import 'package:flutter_hacker_news_prototype/src/clock/clock.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/hacker_news_api.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/item.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/story_type.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/user.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeHackerNewsApi implements HackerNewsApi {
  FakeHackerNewsApi([this.clock = const Clock()]);

  final Clock clock;

  @override
  Future<Item> item(int id, {bool cached = true}) async {
    await Future.delayed(Duration(milliseconds: 100));
    return Item(
      id: id,
      deleted: false,
      type: 'story',
      by: 'user-name',
      time: cached
          ? 0
          : DateTime.now().millisecondsSinceEpoch ~/ 1000, // secondsSinceEpoch
      text: 'item-text',
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
    return User(
      id: 'user-name',
      created: 0,
      karma: 0,
      about: 'user-about',
      submitted: [0, 1, 2, 3, 4, 5],
    );
  }

  @override
  Future<List<int>> stories(StoryType storyType, {bool cached = true}) async {
    return [1, 2, 3, 4, 5];
  }
}
