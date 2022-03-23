import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'logger.dart';
import 'src/hacker_news_api.dart';
import 'src/hacker_news_notifier.dart';
import 'src/ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureLogger(kDebugMode);

  final hackerNewsApi = HackerNewsApiImpl(Client());
  final hackerNewsNotifier = HackerNewsNotifier(hackerNewsApi)
    ..loadBeststories(5, 0);
  // HackerNewsItemNotifier(hackerNewsApi)..loadItem(id),

  runApp(
    MultiProvider(
      providers: [
        Provider<HackerNewsApi>.value(value: hackerNewsApi),
        ChangeNotifierProvider<HackerNewsNotifier>.value(value: hackerNewsNotifier),
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
      home: TopstoriesView(),
    );
  }
}
