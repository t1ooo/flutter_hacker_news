import 'dart:convert';

import 'package:flutter_hacker_news_prototype/src/hacker_news_api/hacker_news_api.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/http_client.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/item.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/story_type.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  // test('HackerNewsApi stories test', () async {
  //   // final result = [1, 2, 3, 4, 5];

  //   // final uri = Uri.parse(
  //   //   'https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty',
  //   // );
  //   // final body = jsonEncode(result);

  //   // registerFallbackValue(Duration.zero);

  //   // final httpClient = FakeHttpClient();
  //   // when(() => httpClient.getBody(uri, maxAge: any(named: 'maxAge')))
  //   //     .thenAnswer((_) async => body);

  //   // final api = HackerNewsApiImpl(httpClient);

  //   // // final stories = await api.stories(StoryType.best);
  //   // // expect(stories, result);

  // });

  for (final type in StoryType.values) {
    testStories(type);
  }

  testItem(0, Item(id: 0));
  testItem(1, Item(id: 1));

  testUser('test-user-0', User(id: 'test-user-0', created: 0, karma: 0));
  testUser('test-user-1', User(id: 'test-user-1', created: 1, karma: 1));
}

void testStories(StoryType type) {
  test('HackerNewsApi stories:${type.toText()} test', () async {
    final result = [1, 2, 3, 4, 5];

    // final uri = 'https://hacker-news.firebaseio.com/v0/'
    //     '${type.toText()}stories.json?print=pretty';
    final uri = UriBuilder.stories(type);

    // registerFallbackValue(Duration.zero);

    // final httpClient = FakeHttpClient();
    // when(
    //   () => httpClient.getBody(Uri.parse(uri), maxAge: any(named: 'maxAge')),
    // ).thenAnswer(
    //   (_) async => jsonEncode(result),
    // );
    final httpClient = httpClientMock(uri, jsonEncode(result));

    final api = HackerNewsApiImpl(httpClient);

    final stories = await api.stories(type);
    expect(stories, result);
  });
}

void testItem(int id, Item result) {
  test('HackerNewsApi item test', () async {
    // final uri =
    //     'https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty';
    final uri = UriBuilder.item(id);

    // registerFallbackValue(Duration.zero);

    // final httpClient = FakeHttpClient();
    // when(
    //   () => httpClient.getBody(Uri.parse(uri), maxAge: any(named: 'maxAge')),
    // ).thenAnswer(
    //   (_) async => jsonEncode(result.toJson()),
    // );
    final httpClient = httpClientMock(uri, jsonEncode(result.toJson()));

    final api = HackerNewsApiImpl(httpClient);

    final item = await api.item(id);
    expect(item, result);
  });
}

void testUser(String name, User result) {
  test('HackerNewsApi item test', () async {
    // final uri =
    //     'https://hacker-news.firebaseio.com/v0/user/$name.json?print=pretty';
    final uri = UriBuilder.user(name);

    // registerFallbackValue(Duration.zero);

    // final httpClient = FakeHttpClient();
    // when(
    //   () => httpClient.getBody(Uri.parse(uri), maxAge: any(named: 'maxAge')),
    // ).thenAnswer(
    //   (_) async => jsonEncode(result.toJson()),
    // );
    final httpClient = httpClientMock(uri, jsonEncode(result.toJson()));

    final api = HackerNewsApiImpl(httpClient);

    final item = await api.user(name);
    expect(item, result);
  });
}

class FakeHttpClient extends Mock implements HttpClient {}

HttpClient httpClientMock(Uri uri, String body) {
  registerFallbackValue(Duration.zero);

  final httpClient = FakeHttpClient();
  when(
    () => httpClient.getBody(uri, maxAge: any(named: 'maxAge')),
  ).thenAnswer(
    (_) async => body,
  );

  return httpClient;
}


// class FakeHttpClient implements HttpClient {
//   @override
//   Future<String> getBody(
//     Uri uri, {
//     Duration maxAge = Duration.zero,
//     int maxAttempts = 8,
//     CheckResponse checkResponse = defaultCheckResponse,
//     Duration timeout = const Duration(seconds: 30),
//   }) async {
//     switch (uri.toString()) {
//       case 'https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty':
//         return File('').readAsStringSync();
//       case 'https://hacker-news.firebaseio.com/v0/item/0.json?print=pretty':
//         return File('').readAsStringSync();
//       case 'https://hacker-news.firebaseio.com/v0/user/test-user.json?print=pretty':
//         return File('').readAsStringSync();
//       default:
//         throw Exception('unsupported uri: $uri');
//     }
//   }
// }



