import 'dart:convert';

import '../logging/logging.dart';

import 'http_client.dart';
import 'item.dart';
import 'story_type.dart';
import 'user.dart';

String _e(String s) => Uri.encodeComponent(s);

Uri uri(String uri) => Uri.parse(uri);

// ignore: avoid_classes_with_only_static_members
class UriBuilder {
  static const String base = 'https://hacker-news.firebaseio.com/v0';

  static Uri item(int id) => uri('$base/item/$id.json');

  static Uri user(String name) => uri('$base/user/${_e(name)}.json');

  static Uri stories(StoryType type) =>
      uri('$base/${type.toText()}stories.json');

  // static const String maxitem = '/maxitem.json';
  // static const String updates = '/updates.json';
}

abstract class HackerNewsApi {
  Future<Item> item(int id, {bool cached = true});
  Future<User> user(String name, {bool cached = true});
  Future<List<int>> stories(StoryType storyType, {bool cached = true});
}

class HackerNewsApiImpl implements HackerNewsApi {
  HackerNewsApiImpl(this.client);

  final HttpClient client;
  // ignore: unused_field
  static final _log = Logger('HackerNewsApiImpl');

  @override
  Future<List<int>> stories(StoryType storyType, {bool cached = true}) async {
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
