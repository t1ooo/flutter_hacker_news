import 'dart:convert';

import '../logging/logging.dart';

import 'http_client.dart';
import 'item.dart';
import 'story_type.dart';
import 'user.dart';

String _e(String s) => Uri.encodeComponent(s);

// ignore: avoid_classes_with_only_static_members
class UriBuilder {
  static const String base = 'https://hacker-news.firebaseio.com/v0';
  static Uri item(int id) => Uri.parse('$base/item/$id.json?print=pretty');
  static Uri user(String name) =>
      Uri.parse('$base/user/${_e(name)}.json?print=pretty');
  static Uri stories(StoryType type) =>
      Uri.parse('$base/${type.toText()}stories.json?print=pretty');
  // static const String topstories = '/topstories.json?print=pretty';
  // static const String newstories = '/newstories.json?print=pretty';
  // static const String beststories = '/beststories.json?print=pretty';
  // static const String askstories = '/askstories.json?print=pretty';
  // static const String showstories = '/showstories.json?print=pretty';
  // static const String jobstories = '/jobstories.json?print=pretty';

  // static const String maxitem = '/maxitem.json?print=pretty';
  // static const String updates = '/updates.json?print=pretty';
}

// String _storyPath(StoryType storyType) {
//   switch (storyType) {
//     case StoryType.top:
//       return UriBuilder.topstories;
//     case StoryType.new_:
//       return UriBuilder.newstories;
//     case StoryType.best:
//       return UriBuilder.beststories;
//     case StoryType.ask:
//       return UriBuilder.askstories;
//     case StoryType.show:
//       return UriBuilder.showstories;
//     case StoryType.job:
//       return UriBuilder.jobstories;
//   }
// }

abstract class HackerNewsApi {
  Future<Item> item(int id, {bool cached = true});
  Future<User> user(String name, {bool cached = true});
  Future<List<int>> stories(StoryType storyType, {bool cached = true});
}

class HackerNewsApiImpl implements HackerNewsApi {
  HackerNewsApiImpl(this.client);

  final HttpClient client;
  static final _log = Logger('HackerNewsApiImpl');

  @override
  Future<List<int>> stories(StoryType storyType, {bool cached = true}) async {
    // final uri = Uri.parse(UriBuilder.base + _storyPath(storyType));
    final uri = UriBuilder.stories(storyType);
    final maxAge = Duration(minutes: cached ? 5 : 0);
    final body = await client.getBody(uri, maxAge: maxAge);
    return (jsonDecode(body) as List).map((v) => v as int).toList();
  }

  @override
  Future<Item> item(int id, {bool cached = true}) async {
    final uri = UriBuilder.item(id);
    final maxAge = Duration(minutes: cached ? 5 : 0);
    final body = await client.getBody(uri, maxAge: maxAge);
    return Item.fromJson(jsonDecode(body) as Map<String, dynamic>);
  }

  @override
  Future<User> user(String name, {bool cached = true}) async {
    final uri = UriBuilder.user(name);
    final maxAge = Duration(minutes: cached ? 5 : 0);
    final body = await client.getBody(uri, maxAge: maxAge);
    return User.fromJson(jsonDecode(body) as Map<String, dynamic>);
  }
}

DateTime dateTimeUnixTime(int unixTimeSec) {
  return DateTime.fromMillisecondsSinceEpoch(unixTimeSec * 1000);
}
