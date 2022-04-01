// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_hacker_news_prototype/logger.dart';
import 'package:flutter_hacker_news_prototype/src/app.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/hacker_news_api.dart';
import 'package:flutter_hacker_news_prototype/src/stories/stories_screen.dart';
import 'package:flutter_hacker_news_prototype/src/story/story_screen.dart';
import 'package:flutter_hacker_news_prototype/src/user/user_screen.dart';
import 'package:flutter_hacker_news_prototype/src/user_activities/user_activities_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Future<Provider<HackerNewsApi>> testHackerNewsApiProvider() async {
  return Provider<HackerNewsApi>.value(value: FakeHackerNewsApi());
}

Widget withMaterial(Widget child) {
  return MaterialApp(home: child);
}

Future<void> widgetTester(String name, Widget child) async {
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

Future<void> main() async {
  await widgetTester('MyApp widget smoke test', MyApp());

  // NOTE: throw exception(No MediaQuery widget ancestor found) without Material
  await widgetTester(
    'MyApp widget smoke test',
    withMaterial(StoriesScreen()),
  );
  await widgetTester(
    'MyApp widget smoke test',
    withMaterial(StoryScreen(id: 0)),
  );
  await widgetTester(
    'MyApp widget smoke test',
    withMaterial(UserActivitiesScreen(name: 'test-user')),
  );
  await widgetTester(
    'MyApp widget smoke test',
    withMaterial(UserScreen(name: 'test-user')),
  );

  // testWidgets('MyApp widget smoke test', (WidgetTester tester) async {
  //   configureLogger(true);
  //   final _hackerNewsApiProvider = await testHackerNewsApiProvider();

  //   await tester.pumpWidget(
  //     MultiProvider(
  //       providers: [
  //         _hackerNewsApiProvider,
  //       ],
  //       child: MyApp(),
  //     ),
  //   );
  // });

  // testWidgets('StoriesScreen widget smoke test', (WidgetTester tester) async {
  //   configureLogger(true);
  //   final _hackerNewsApiProvider = await testHackerNewsApiProvider();

  //   await tester.pumpWidget(
  //     MultiProvider(
  //       providers: [
  //         _hackerNewsApiProvider,
  //       ],
  //       // NOTE: throw exception(No MediaQuery widget ancestor found) without Material
  //       child: withMaterial(StoriesScreen()),
  //     ),
  //   );
  // });

  // testWidgets('StoryScreen widget smoke test', (WidgetTester tester) async {
  //   configureLogger(true);
  //   final _hackerNewsApiProvider = await testHackerNewsApiProvider();

  //   await tester.pumpWidget(
  //     MultiProvider(
  //       providers: [
  //         _hackerNewsApiProvider,
  //       ],
  //       child: withMaterial(StoryScreen(id: 0)),
  //     ),
  //   );
  // });

  // testWidgets('UserActivitiesScreen widget smoke test',
  //     (WidgetTester tester) async {
  //   configureLogger(true);
  //   final _hackerNewsApiProvider = await testHackerNewsApiProvider();

  //   await tester.pumpWidget(
  //     MultiProvider(
  //       providers: [
  //         _hackerNewsApiProvider,
  //       ],
  //       child: withMaterial(UserActivitiesScreen(name: 'test-user')),
  //     ),
  //   );
  // });

  // testWidgets('UserScreen widget smoke test', (WidgetTester tester) async {
  //   configureLogger(true);
  //   final _hackerNewsApiProvider = await testHackerNewsApiProvider();

  //   await tester.pumpWidget(
  //     MultiProvider(
  //       providers: [
  //         _hackerNewsApiProvider,
  //       ],
  //       child: withMaterial(UserScreen(name: 'test-user')),
  //     ),
  //   );
  // });
}
