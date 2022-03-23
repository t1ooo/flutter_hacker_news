import 'dart:convert';

import 'package:http/http.dart' show Client;

import 'item.dart';
import 'updates.dart';
import 'user.dart';

String _e(String s) => Uri.encodeComponent(s);

Future<T> retry<T>(Future<T> Function() fn, [int tryN = 1]) async {
  Exception? exception;
  for (int t = 0; t < tryN; t++) {
    try {
      return await fn();
    } on Exception catch (e) {
      exception = e;
    }
  }

  throw (exception ?? Exception('failed to try'));
}

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
  Future<Item> item(int id);
  Future<User> user(String name);
  Future<int> maxitem();
  Future<List<int>> topstories();
  Future<List<int>> newstories();
  Future<List<int>> beststories();
  Future<List<int>> askstories();
  Future<List<int>> showstories();
  Future<List<int>> jobstories();
  Future<Updates> updates();
}

// TODO: retry
// TODO: cache
class HackerNewsApiImpl implements HackerNewsApi {
  final Client client;

  HackerNewsApiImpl(this.client);

  @override
  Future<List<int>> askstories() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.askstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<int>;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<List<int>> beststories() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.beststories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).map((v) => v as int).toList();
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<List<int>> jobstories() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.jobstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<int>;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<List<int>> newstories() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.newstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<int>;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<List<int>> showstories() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.showstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<int>;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<List<int>> topstories() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.topstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).map((v) => v as int).toList();
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<Item> item(int id) async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.item(id));
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<int> maxitem() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.maxitem);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as int;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<Updates> updates() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.updates);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return Updates.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<User> user(String name) async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.user(name));
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load askstories');
    }
  }
}
