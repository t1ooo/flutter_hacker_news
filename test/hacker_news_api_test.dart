import 'dart:convert';

import 'package:flutter_hacker_news_prototype/src/hacker_news_api/hacker_news_api.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/http_client.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/item.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/story_type.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
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

    final uri = UriBuilder.stories(type);
    final httpClient = httpClientMock(uri, jsonEncode(result));
    final api = HackerNewsApiImpl(httpClient);

    final stories = await api.stories(type);
    expect(stories, result);
  });
}

void testItem(int id, Item result) {
  test('HackerNewsApi item test', () async {
    final uri = UriBuilder.item(id);
    final httpClient = httpClientMock(uri, jsonEncode(result.toJson()));
    final api = HackerNewsApiImpl(httpClient);
    final item = await api.item(id);

    expect(item, result);
  });
}

void testUser(String name, User result) {
  test('HackerNewsApi item test', () async {
    final uri = UriBuilder.user(name);
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
