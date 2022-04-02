import 'package:flutter/material.dart';
import 'package:flutter_hacker_news_prototype/logger.dart';
import 'package:flutter_hacker_news_prototype/src/app.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/hacker_news_api.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/item.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/story_type.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/user.dart';
import 'package:flutter_hacker_news_prototype/src/stories/stories_screen.dart';
import 'package:flutter_hacker_news_prototype/src/story/story_screen.dart';
import 'package:flutter_hacker_news_prototype/src/user/user_screen.dart';
import 'package:flutter_hacker_news_prototype/src/user_activities/user_activities_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await widgetSmokeTest('MyApp widget smoke test', MyApp());

  // NOTE: throw exception(No MediaQuery widget ancestor found) without Material
  await widgetSmokeTest(
    'MyApp widget smoke test',
    withMaterial(StoriesScreen()),
  );
  await widgetSmokeTest(
    'MyApp widget smoke test',
    withMaterial(StoryScreen(id: 0)),
  );
  await widgetSmokeTest(
    'MyApp widget smoke test',
    withMaterial(UserActivitiesScreen(name: 'test-user')),
  );
  await widgetSmokeTest(
    'MyApp widget smoke test',
    withMaterial(UserScreen(name: 'test-user')),
  );
}

Future<Provider<HackerNewsApi>> testHackerNewsApiProvider() async {
  return Provider<HackerNewsApi>.value(value: FakeHackerNewsApi());
}

Widget withMaterial(Widget child) {
  return MaterialApp(home: child);
}

Future<void> widgetSmokeTest(String name, Widget child) async {
  testWidgets(name, (WidgetTester tester) async {
    configureLogger(true);
    final _hackerNewsApiProvider = await testHackerNewsApiProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          _hackerNewsApiProvider,
        ],
        child: child,
      ),
    );
  });
}

class FakeHackerNewsApi implements HackerNewsApi {
  @override
  Future<Item> item(int id, {bool cached = true}) async {
    return Item(
      id: 0,
      deleted: false,
      type: 'story',
      by: 'user-name',
      time: 0,
      text: 'item-text',
      dead: false,
      parent: 0,
      poll: 0,
      kids: id < 5 ? [id + 1, id + 2, id + 3] : [],
      url: 'https://example.com',
      score: 0,
      title: 'item-title',
      parts: 0,
      descendants: 0,
    );
  }

  @override
  Future<User> user(String name, {bool cached = true}) async {
    return User(
      id: 'user-name',
      created: 0,
      karma: 0,
      about: 'user-about',
      submitted: [0, 1, 2, 3, 4, 5],
    );
  }

  @override
  Future<List<int>> stories(StoryType storyType, {bool cached = true}) async {
    return [1, 2, 3, 4, 5];
  }
}
