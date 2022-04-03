import 'package:flutter/material.dart';
import 'package:flutter_hacker_news_prototype/src/app.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/hacker_news_api.dart';
import 'package:flutter_hacker_news_prototype/src/stories/stories_screen.dart';
import 'package:flutter_hacker_news_prototype/src/story/story_screen.dart';
import 'package:flutter_hacker_news_prototype/src/user/user_screen.dart';
import 'package:flutter_hacker_news_prototype/src/user_activities/user_activities_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'fake_hacker_news_api.dart';

Future<void> main() async {
  renderWidget('render MyApp', MyApp());

  // NOTE: throw exception(No MediaQuery widget ancestor found) without Material
  renderWidget(
    'render StoriesScreen',
    withMaterial(StoriesScreen()),
  );
  renderWidget(
    'render StoryScreen',
    withMaterial(StoryScreen(id: 0)),
  );
  renderWidget(
    'render UserActivitiesScreen',
    withMaterial(UserActivitiesScreen(name: 'test-user')),
  );
  renderWidget(
    'render UserScreen',
    withMaterial(UserScreen(name: 'test-user')),
  );
}

Future<Provider<HackerNewsApi>> testHackerNewsApiProvider() async {
  return Provider<HackerNewsApi>.value(value: FakeHackerNewsApi());
}

Widget withMaterial(Widget child) {
  return MaterialApp(home: child);
}

void renderWidget(String name, Widget child) {
  testWidgets(name, (WidgetTester tester) async {
    final _hackerNewsApiProvider = await testHackerNewsApiProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          _hackerNewsApiProvider,
        ],
        child: child,
      ),
    );

    await tester.pumpAndSettle();
  });
}
