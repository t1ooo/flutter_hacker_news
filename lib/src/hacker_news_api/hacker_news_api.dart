import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:retry/retry.dart';

import 'cache.dart';
import 'item.dart';
import 'story_type.dart';
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
  Future<Item> item(int id, [bool cached=true]);
  Future<User> user(String name, [bool cached=true]);
  // Future<int> maxitem();
  // Future<List<int>> topstories();
  // Future<List<int>> newstories();
  // Future<List<int>> beststories();
  // Future<List<int>> askstories();
  // Future<List<int>> showstories();
  // Future<List<int>> jobstories();
  // Future<Updates> updates();
  Future<List<int>> stories(StoryType storyType, [bool cached=true]);
}

// TODO: retry
// TODO: cache
class HackerNewsApiImpl implements HackerNewsApi {
  HackerNewsApiImpl(this.client, [this.cache]);

  final Client client;
  final Cache? cache;
  static const _itemCacheMaxAge = Duration(hours: 24);
  static const _storyCacheMaxAge = Duration(minutes: 5);

  Future<Response> _get(Uri uri) async {
    return await retry(() => client.get(uri));
  }

  Future<String> _getBody(Uri uri, Duration maxAge, bool cached) async {
    // return await retry(() => client.get(uri));

    // if (cache != null) {
    //   final body = await cache!.get(uri.toString());
    //   if (body != null) {
    //     return body;
    //   }
    // }

    if (cached) {
      final body = await cache?.get(uri.toString());
      if (body != null) {
        return body;
      }
    }

    return await retry(() async {
      final response = await client.get(uri);
      if (response.statusCode == 200) {
        if (cached) {
          await cache?.put(uri.toString(), response.body, maxAge);
        }
        // if (cache != null) {
        // await cache!.put(uri.toString(), response.body, Duration(minutes: 5));
        // }
        return response.body;
      }
      throw Exception('statusCode != 200');
    });
  }

  @override
  Future<List<int>> stories(StoryType storyType, [bool cached=true]) async {
    final uri = Uri.parse(HackerNewsURI.base + _storyPath(storyType));
    final body = await _getBody(uri, _storyCacheMaxAge, cached);
    return (jsonDecode(body) as List).map((v) => v as int).toList();
  }

  String _storyPath(StoryType storyType) {
    switch (storyType) {
      case StoryType.top:
        return HackerNewsURI.topstories;
      case StoryType.new_:
        return HackerNewsURI.newstories;
      case StoryType.best:
        return HackerNewsURI.beststories;
      case StoryType.ask:
        return HackerNewsURI.askstories;
      case StoryType.show:
        return HackerNewsURI.showstories;
      case StoryType.job:
        return HackerNewsURI.jobstories;
    }
  }

  // @override
  // Future<List<int>> askstories() async {
  //   final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.askstories);
  //   final body = await _getBody(uri, _storyCacheMaxAge);
  //   return jsonDecode(body) as List<int>;
  // }

  // @override
  // Future<List<int>> beststories() async {
  //   final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.beststories);
  //   final body = await _getBody(uri, _storyCacheMaxAge);
  //   return (jsonDecode(body) as List).map((v) => v as int).toList();
  //   // final response = await _get(uri);
  //   // if (response.statusCode == 200) {
  //   // return (jsonDecode(response.body) as List).map((v) => v as int).toList();
  //   // } else {
  //   // throw Exception('failed to load askstories');
  //   // }
  // }

  // @override
  // Future<List<int>> jobstories() async {
  //   final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.jobstories);
  //   final response = await _get(uri);
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body) as List<int>;
  //   } else {
  //     throw Exception('failed to load askstories');
  //   }
  // }

  // @override
  // Future<List<int>> newstories() async {
  //   final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.newstories);
  //   final response = await _get(uri);
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body) as List<int>;
  //   } else {
  //     throw Exception('failed to load askstories');
  //   }
  // }

  // @override
  // Future<List<int>> showstories() async {
  //   final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.showstories);
  //   final response = await _get(uri);
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body) as List<int>;
  //   } else {
  //     throw Exception('failed to load askstories');
  //   }
  // }

  // @override
  // Future<List<int>> topstories() async {
  //   final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.topstories);
  //   final body = await _getBody(uri, _storyCacheMaxAge);
  //   return (jsonDecode(body) as List).map((v) => v as int).toList();
  //   // final response = await _get(uri);
  //   // if (response.statusCode == 200) {
  //   //   return (jsonDecode(response.body) as List).map((v) => v as int).toList();
  //   // } else {
  //   //   throw Exception('failed to load askstories');
  //   // }
  // }

  @override
  Future<Item> item(int id, [bool cached=true]) async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.item(id));
    final body = await _getBody(uri, _itemCacheMaxAge, cached);
    return Item.fromJson(jsonDecode(body));
    // final response = await _get(uri);
    // if (response.statusCode == 200) {
    //   return Item.fromJson(jsonDecode(response.body));
    // } else {
    //   throw Exception('failed to load askstories');
    // }
  }

  // @override
  // Future<int> maxitem() async {
  //   final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.maxitem);
  //   final response = await _get(uri);
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body) as int;
  //   } else {
  //     throw Exception('failed to load askstories');
  //   }
  // }

  // @override
  // Future<Updates> updates() async {
  //   final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.updates);
  //   final response = await _get(uri);
  //   if (response.statusCode == 200) {
  //     return Updates.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('failed to load askstories');
  //   }
  // }

  @override
  Future<User> user(String name, [bool cached=true]) async {
    final uri = Uri.parse(HackerNewsURI.base + HackerNewsURI.user(name));
    final body = await _getBody(uri, _itemCacheMaxAge, cached);
    return User.fromJson(jsonDecode(body));
    // final response = await _get(uri);
    // if (response.statusCode == 200) {
    //   return User.fromJson(jsonDecode(response.body));
    // } else {
    //   throw Exception('failed to load askstories');
    // }
  }
}
