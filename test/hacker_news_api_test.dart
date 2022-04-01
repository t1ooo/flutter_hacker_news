import 'package:flutter_hacker_news_prototype/src/hacker_news_api/hacker_news_api.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/http_client.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/story_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// class FakeHttpClient extends Mock implements HttpClient {}
class FakeHttpClient extends Mock implements HttpClientImpl {}

class Cat {
  String sound() => 'meow!';
  bool likes(String food, {bool isHungry = false}) => false;
  final int lives = 9;
}

// A Mock Cat class
class MockCat extends Mock implements Cat {}

void main() {
  test('test', () async {
    final httpClient = FakeHttpClient();
    // ignore: avoid_dynamic_calls
    // when(() => httpClient.getBody(Uri.parse('https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty')).thenReturn('[1,2,3,4,5]'));

    final uri = Uri.parse(
        'https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty');

    // when(() => httpClient.getBody(uri));
    // final w = when(() => httpClient.getBody(uri));
    // expect((await httpClient.getBody(uri)) is Mock, true);
    // when(() => httpClient.getBody(uri)).calls(Symbol('getBody'));
    // when(httpClient.getBody).thenAnswer((_) async {});

    registerFallbackValue(Duration.zero);

    when(() => httpClient.getBody(uri, maxAge: any(named: 'maxAge')))
        .thenAnswer((_) => Future<String>.value('[1,2,3,4,5]'));
    // final cat = MockCat();
    // when(() => cat.sound()).thenReturn('meow');

    // .thenReturn('[1,2,3,4,5]');

    final api = HackerNewsApiImpl(httpClient);
    final stories = await api.stories(StoryType.best);
    expect(stories, [1, 2, 3, 4, 5]);
  });
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



