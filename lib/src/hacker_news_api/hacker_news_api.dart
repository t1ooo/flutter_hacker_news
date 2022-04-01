import 'dart:convert';

import '../logging/logging.dart';

import 'http_client.dart';
import 'item.dart';
import 'story_type.dart';
import 'user.dart';

String _e(String s) => Uri.encodeComponent(s);

// ignore: avoid_classes_with_only_static_members
class _URI {
  static const String base = 'https://hacker-news.firebaseio.com/v0';
  static String item(int id) => '/item/$id.json?print=pretty';
  static String user(String name) => '/user/${_e(name)}.json?print=pretty';
  static const String maxitem = '/maxitem.json?print=pretty';
  static const String topstories = '/topstories.json?print=pretty';
  static const String newstories = '/newstories.json?print=pretty';
  static const String beststories = '/beststories.json?print=pretty';
  static const String askstories = '/askstories.json?print=pretty';
  static const String showstories = '/showstories.json?print=pretty';
  static const String jobstories = '/jobstories.json?print=pretty';
  static const String updates = '/updates.json?print=pretty';
}

String _storyPath(StoryType storyType) {
  switch (storyType) {
    case StoryType.top:
      return _URI.topstories;
    case StoryType.new_:
      return _URI.newstories;
    case StoryType.best:
      return _URI.beststories;
    case StoryType.ask:
      return _URI.askstories;
    case StoryType.show:
      return _URI.showstories;
    case StoryType.job:
      return _URI.jobstories;
  }
}

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
    final uri = Uri.parse(_URI.base + _storyPath(storyType));
    final body = await client.getBody(
      uri,
      maxAge: Duration(minutes: cached ? 5 : 0),
    );
    return (jsonDecode(body) as List).map((v) => v as int).toList();
  }

  @override
  Future<Item> item(int id, {bool cached = true}) async {
    final uri = Uri.parse(_URI.base + _URI.item(id));
    final body = await client.getBody(
      uri,
      maxAge: Duration(minutes: cached ? 5 : 0),
    );
    return Item.fromJson(jsonDecode(body) as Map<String, dynamic>);
  }

  @override
  Future<User> user(String name, {bool cached = true}) async {
    final uri = Uri.parse(_URI.base + _URI.user(name));
    final body = await client.getBody(
      uri,
      maxAge: Duration(minutes: cached ? 5 : 0),
    );
    return User.fromJson(jsonDecode(body) as Map<String, dynamic>);
  }
}
