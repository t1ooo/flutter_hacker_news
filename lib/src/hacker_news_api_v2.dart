import 'dart:convert';

import 'package:http/http.dart' show Client;

import 'item_v2.dart';
import 'updates.dart';
import 'user.dart';

String _e(String s) => Uri.encodeComponent(s);

class HackerNewsURI {
  static const String base = 'https://hacker-news.firebaseio.com';
  static String item(int id) => '/v0/item/$id.json?print=pretty';
  static String user(String name) => '/v0/user/${_e(name)}.json?print=pretty';
  static const String maxitem = '/v0/maxitem.json?print=pretty';
  static const String topstories = '/v0/topstories.json?print=pretty';
  static const String newstories = '/v0/newstories.json?print=pretty';
  static const String beststories = '/v0/beststories.json?print=pretty';
  static const String askstories = '/v0/askstories.json?print=pretty';
  static const String showstories = '/v0/showstories.json?print=pretty';
  static const String jobstories = '/v0/jobstories.json?print=pretty';
  static const String updates = '/v0/updates.json?print=pretty';
}

abstract class HackerNewsApi {
  Future<Item> item(int id, int limit);
  Future<User> user(String name);
  Future<int> maxitem();
  Future<List<Item>> topstories(int limit);
  Future<List<Item>> newstories(int limit);
  Future<List<Item>> beststories(int limit);
  Future<List<Item>> askstories(int limit);
  Future<List<Item>> showstories(int limit);
  Future<List<Item>> jobstories(int limit);
  Future<Updates> updates();
}

// TODO: retry
class HackerNewsApiImpl implements HackerNewsApi {
  final Client client;

  HackerNewsApiImpl(this.client);

  Future<List<Item>> _stories(String uriStr, int limit) async {
    final uri = Uri.parse(uriStr);
    final response = await client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('failed to load stories');
    }
    try {
      final items_ids =
          (jsonDecode(response.body) as List).map((v) => v as int).toList();
      final items = <Item>[];
      for (final item_id in items_ids) {
        items.add(await item(item_id, limit));
      }
      return items;
    } on Exception catch (_) {
      print(response.body);
      rethrow;
    }
  }

  @override
  Future<List<Item>> askstories(int limit) async {
    final uri = HackerNewsURI.base + HackerNewsURI.askstories;
    return _stories(uri, limit);
  }

  @override
  Future<List<Item>> beststories(int limit) async {
    final uri = HackerNewsURI.base + HackerNewsURI.beststories;
    return _stories(uri, limit);
  }

  @override
  Future<List<Item>> jobstories(int limit) async {
    final uri = HackerNewsURI.base + HackerNewsURI.jobstories;
    return _stories(uri, limit);
  }

  @override
  Future<List<Item>> newstories(int limit) async {
    final uri = HackerNewsURI.base + HackerNewsURI.newstories;
    return _stories(uri, limit);
  }

  @override
  Future<List<Item>> showstories(int limit) async {
    final uri = HackerNewsURI.base + HackerNewsURI.showstories;
    return _stories(uri, limit);
  }

  @override
  Future<List<Item>> topstories(int limit) async {
    final uri = HackerNewsURI.base + HackerNewsURI.topstories;
    return _stories(uri, limit);
  }

  @override
  Future<Item> item(int id, int limit) async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.item(id));
    final response = await client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('failed to load item');
    }

    try {
      // return Item.fromJson(jsonDecode(response.body));
      final it = Item.fromJson(jsonDecode(response.body));
      if (it.kids != null) {
        final items = <Item>[];
        for (final item_id in it.kids!) {
          items.add(await item(item_id, limit));
        }
        it.kidsItems = items;
      }
      return it;
    } on Exception catch (_) {
      print(response.body);
      rethrow;
    }
  }

  @override
  Future<int> maxitem() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.maxitem);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as int;
    } else {
      throw Exception('failed to load maxitem');
    }
  }

  @override
  Future<Updates> updates() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.updates);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return Updates.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load updates');
    }
  }

  @override
  Future<User> user(String name) async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.user(name));
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load user');
    }
  }
}
