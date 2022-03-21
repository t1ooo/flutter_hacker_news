import 'dart:convert';

import 'package:http/http.dart' show Client;

import 'item.dart';
import 'updates.dart';
import 'user.dart';

class HackerNewsURI {
  static const String base = 'https://hacker-news.firebaseio.com';
  static const String item = '/v0/item/<id>';
  static const String user = '/v0/user/';
  static const String maxitem = '/v0/maxitem';
  static const String topstories = '/v0/topstories';
  static const String newstories = '/v0/newstories';
  static const String beststories = '/v0/beststories';
  static const String askstories = '/v0/askstories';
  static const String showstories = '/v0/showstories';
  static const String jobstories = '/v0/jobstories';
  static const String updates = '/v0/updates';
}

abstract class HackerNewsApi {
  Future<Item> item(int id);
  Future<User> user();
  Future<int> maxitem();
  Future<List<int>> topstories();
  Future<List<int>> newstories();
  Future<List<int>> beststories();
  Future<List<int>> askstories();
  Future<List<int>> showstories();
  Future<List<int>> jobstories();
  Future<Updates> updates();
}

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
      return jsonDecode(response.body) as List<int>;
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
      return jsonDecode(response.body) as List<int>;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<Item> item(int id)  async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.topstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<int> maxitem()  async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.topstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as int;
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<Updates> updates() async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.topstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return Updates.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load askstories');
    }
  }

  @override
  Future<User> user()  async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.topstories);
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('failed to load askstories');
    }
  }
}
