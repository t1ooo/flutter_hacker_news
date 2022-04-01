// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hacker_news_prototype/logger.dart';
import 'package:flutter_hacker_news_prototype/src/app.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/cache.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/hacker_news_api.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/http_client.dart';
import 'package:flutter_hacker_news_prototype/src/notifier/story_notifier.dart';
import 'package:flutter_hacker_news_prototype/src/provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

Future<Provider<HackerNewsApi>> testHackerNewsApiProvider() async {
  final cache = EternalFileCache(
    File(
      '/home/graibn/GoogleDrive/dev/project/source/flutter_hacker_news_prototype/data/data.json',
    ),
  );
  await cache.load();
  final httpClient = HttpClientImpl(Client(), cache, Throttle());
  final hackerNewsApi = HackerNewsApiImpl(httpClient);

  return Provider.value(value: hackerNewsApi);
}

void main() {
  testWidgets('app widget smoke test', (WidgetTester tester) async {
    // // Build our app and trigger a frame.
    // await tester.pumpWidget(MyApp());

    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);

    // WidgetsFlutterBinding.ensureInitialized();

    configureLogger(true);

    // final _hackerNewsApiProvider = await hackerNewsApiProvider();

    // final cache = EternalFileCache(
    //   File(
    //     '/home/graibn/GoogleDrive/dev/project/source/flutter_hacker_news_prototype/data/data.json',
    //   ),
    // );
    // await cache.load();
    // final httpClient = HttpClientImpl(Client(), cache, Throttle());
    // final hackerNewsApi = HackerNewsApiImpl(httpClient);

    // final hackerNewsApi = FakeHackerNewsApi();
    // final _hackerNewsApiProvider = Provider<HackerNewsApi>.value(value: FakeHackerNewsApi());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<HackerNewsApi>.value(value: FakeHackerNewsApi()),
        ],
        child: MyApp(),
      ),
    );

    // final httpClient = HttpClientImpl(Client(), NoCache(), Throttle());
    // final hackerNewsApi = HackerNewsApiImpl(httpClient);
    // await tester.pumpWidget(
    //   MultiProvider(
    //     providers: [
    //       // Provider<HackerNewsApi>.value(value: hackerNewsApi),
    //       _hackerNewsApiProvider,
    //       ChangeNotifierProvider<StoryNotifier>(
    //         create: (BuildContext context) => StoryNotifier(
    //           context.read<HackerNewsApi>(),
    //         ),
    //       ),
    //     ],
    //     child: MyApp(),
    //   ),
    // );
    print('done');
    // await Future.delayed(Duration(seconds: 5));

    // cache.dispose();
  });
}
