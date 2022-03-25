import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'logger.dart';
import 'src/cache.dart';
import 'src/clock/clock.dart';
import 'src/hacker_news_api.dart';
import 'src/hacker_news_notifier.dart';
import 'src/stories/stories_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureLogger(kDebugMode);

  final clock = Clock();
  // final cache = InMemoryCache(clock);
  final cache = FileCache(clock);
  final hackerNewsApi = HackerNewsApiImpl(Client(), cache);
  final hackerNewsNotifier = HackerNewsNotifier(hackerNewsApi);
  // HackerNewsItemNotifier(hackerNewsApi)..loadItem(id),

  runApp(
    MultiProvider(
      providers: [
        Provider<HackerNewsApi>.value(value: hackerNewsApi),
        ChangeNotifierProvider<HackerNewsNotifier>.value(
            value: hackerNewsNotifier),
        // RepositoryProvider.value(value: timerRepo),
        // RepositoryProvider.value(value: notificationService),
      ],
      child: MyApp(),
    ),
  );

  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StoriesScreen(),
    );
  }
}
