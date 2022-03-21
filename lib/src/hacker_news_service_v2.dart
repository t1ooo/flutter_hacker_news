import 'dart:convert';

import 'package:http/http.dart' show Client;

import 'item_v2.dart';
import 'updates.dart';
import 'user.dart';

// TODO: retry
class HackerNewsService {
  final HackerNewsApi client;

  HackerNewsService(this.api);

  Future<List<Item>> _stories(String uriStr, int limit, [int offset=0]) async {
    final uri = Uri.parse(uriStr);
    final response = await client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('failed to load stories');
    }
    try {
      final items_ids =
          (jsonDecode(response.body) as List).map((v) => v as int).toList();
      // final items = <Item>[];
      // for (final item_id in items_ids) {
      //   if (items.length >= limit) {
      //     break;
      //   }
      //   items.add(await item(item_id, 0));
      // }
      // return items;
      return await Future.wait(items_ids.skip(offset).take(limit).map((id) => item(id, 0)));
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
        // final items = <Item>[];
        // for (final item_id in it.kids!) {
        //   if (items.length >= limit) {
        //     break;
        //   }
        //   items.add(await item(item_id, limit));
        // }
        // it.kidsItems = items;

        it.kidsItems = await Future.wait(
            it.kids!.take(limit).map((id) => item(id, limit)));
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
