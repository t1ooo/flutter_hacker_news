import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' show Client, Response;
import 'package:retry/retry.dart';

import '../logging/logging.dart';
import 'cache.dart';
import 'http_client.dart';
import 'item.dart';
import 'story_type.dart';
import 'updates.dart';
import 'user.dart';

String _e(String s) => Uri.encodeComponent(s);

class _URI {
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
  Future<Item> item(int id, [bool cached = true]);
  Future<User> user(String name, [bool cached = true]);
  // Future<int> maxitem();
  // Future<List<int>> topstories();
  // Future<List<int>> newstories();
  // Future<List<int>> beststories();
  // Future<List<int>> askstories();
  // Future<List<int>> showstories();
  // Future<List<int>> jobstories();
  // Future<Updates> updates();
  Future<List<int>> stories(StoryType storyType, [bool cached = true]);
}

class HackerNewsApiImpl implements HackerNewsApi {
  HackerNewsApiImpl(this.client, [this.cache]);

  final Client client;
  final Cache? cache;
  static const _itemCacheMaxAge = Duration(minutes: 5);
  static const _storyCacheMaxAge = Duration(minutes: 5);
  static final _log = Logger('HackerNewsApiImpl');

  final delayBetweenRequest = Duration(seconds: 1);
  DateTime lastRequestTime = DateTime.fromMicrosecondsSinceEpoch(0);

  Future<Response> _get(Uri uri) async {
    return await retry(() => client.get(uri));
  }

  Future<String> _getBody(Uri uri, Duration maxAge, bool cached) async {
    // TODO: replace to clock
    // while (true) {
    //   final timeDiff = DateTime.now().difference(lastRequestTime).abs();
    //   if (timeDiff < delayBetweenRequest) {
    //     // print(delayBetweenRequest - timeDiff);
    //     await Future.delayed(delayBetweenRequest - timeDiff);
    //   } else {
    //     break;
    //   }
    // }
    // lastRequestTime = DateTime.now();

    // final timeDiff = DateTime.now().difference(lastRequestTime).abs();
    // if (timeDiff < delayBetweenRequest) {
    //   print(delayBetweenRequest - timeDiff);
    //   await Future.delayed(delayBetweenRequest - timeDiff);
    // }
    // lastRequestTime = DateTime.now();

    await Future.delayed(Duration(seconds: 1));
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
    // print(cached);

    return await retry(() async {
      // _log.info('request: $uri');
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
  Future<List<int>> stories(StoryType storyType, [bool cached = true]) async {
    final uri = Uri.parse(_URI.base + _storyPath(storyType));
    final body = await _getBody(uri, _storyCacheMaxAge, cached);
    return (jsonDecode(body) as List).map((v) => v as int).toList();
  }

  // String _storyPath(StoryType storyType) {
  //   switch (storyType) {
  //     case StoryType.top:
  //       return _URI.topstories;
  //     case StoryType.new_:
  //       return _URI.newstories;
  //     case StoryType.best:
  //       return _URI.beststories;
  //     case StoryType.ask:
  //       return _URI.askstories;
  //     case StoryType.show:
  //       return _URI.showstories;
  //     case StoryType.job:
  //       return _URI.jobstories;
  //   }
  // }

  // @override
  // Future<List<int>> askstories() async {
  //   final uri = Uri.parse(_URI.base + _URI.askstories);
  //   final body = await _getBody(uri, _storyCacheMaxAge);
  //   return jsonDecode(body) as List<int>;
  // }

  // @override
  // Future<List<int>> beststories() async {
  //   final uri = Uri.parse(_URI.base + _URI.beststories);
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
  //   final uri = Uri.parse(_URI.base + _URI.jobstories);
  //   final response = await _get(uri);
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body) as List<int>;
  //   } else {
  //     throw Exception('failed to load askstories');
  //   }
  // }

  // @override
  // Future<List<int>> newstories() async {
  //   final uri = Uri.parse(_URI.base + _URI.newstories);
  //   final response = await _get(uri);
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body) as List<int>;
  //   } else {
  //     throw Exception('failed to load askstories');
  //   }
  // }

  // @override
  // Future<List<int>> showstories() async {
  //   final uri = Uri.parse(_URI.base + _URI.showstories);
  //   final response = await _get(uri);
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body) as List<int>;
  //   } else {
  //     throw Exception('failed to load askstories');
  //   }
  // }

  // @override
  // Future<List<int>> topstories() async {
  //   final uri = Uri.parse(_URI.base + _URI.topstories);
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
  Future<Item> item(int id, [bool cached = true]) async {
    final uri = Uri.parse(_URI.base + _URI.item(id));
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
  //   final uri = Uri.parse(_URI.base + _URI.maxitem);
  //   final response = await _get(uri);
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body) as int;
  //   } else {
  //     throw Exception('failed to load askstories');
  //   }
  // }

  // @override
  // Future<Updates> updates() async {
  //   final uri = Uri.parse(_URI.base + _URI.updates);
  //   final response = await _get(uri);
  //   if (response.statusCode == 200) {
  //     return Updates.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('failed to load askstories');
  //   }
  // }

  @override
  Future<User> user(String name, [bool cached = true]) async {
    final uri = Uri.parse(_URI.base + _URI.user(name));
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

class HackerNewsApiImplV2 implements HackerNewsApi {
  HackerNewsApiImplV2(this.client);

  final HttpClient client;
  static final _log = Logger('HackerNewsApiImplV2');

  @override
  Future<List<int>> stories(StoryType storyType, [bool cached = true]) async {
    final uri = Uri.parse(_URI.base + _storyPath(storyType));
    final body = await client.getBody(
      uri,
      maxAge: Duration(minutes: cached ? 5 : 0),
    );
    return (jsonDecode(body) as List).map((v) => v as int).toList();
  }

  @override
  Future<Item> item(int id, [bool cached = true]) async {
    final uri = Uri.parse(_URI.base + _URI.item(id));
    final body = await client.getBody(
      uri,
      maxAge: Duration(minutes: cached ? 5 : 0),
    );
    return Item.fromJson(jsonDecode(body));
  }

  @override
  Future<User> user(String name, [bool cached = true]) async {
    final uri = Uri.parse(_URI.base + _URI.user(name));
    final body = await client.getBody(
      uri,
      maxAge: Duration(minutes: cached ? 5 : 0),
    );
    return User.fromJson(jsonDecode(body));
  }
}

class FakeHackerNewsApi implements HackerNewsApi {
  Future<Item> item(int id, [bool cached = true]) async {
    return Item(
      id: 0,
      deleted: false,
      type: 'story',
      by: 'user-name',
      time: 0,
      text: 'item-text',
      dead: false,
      parent: 0,
      poll: 234,
      kids: id < 5 ? [id + 1, id + 2, id + 3] : [],
      url: 'https://example.com',
      score: 0,
      title: 'item-title',
      parts: 0,
      descendants: 0,
    );
  }

  Future<User> user(String name, [bool cached = true]) async {
    return User(
      id: 'user-name',
      created: 0,
      karma: 0,
      about: 'user-about',
      submitted: [0, 1, 2, 3, 4, 5],
    );
  }

  Future<List<int>> stories(StoryType storyType, [bool cached = true]) async {
    return [1, 2, 3, 4, 5];
  }
}
