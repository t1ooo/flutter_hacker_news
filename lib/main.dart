import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api/hacker_news_api.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'logger.dart';
import 'src/hacker_news_api/cache.dart';
import 'src/clock/clock.dart';
import 'src/provider/provider.dart';
import 'src/stories/stories_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureLogger(kDebugMode);

  final _hackerNewsApiProvider = await hackerNewsApiProvider();

  runApp(
    MultiProvider(
      providers: [
        _hackerNewsApiProvider,
      ],
      child: MyApp(),
    ),
  );
}

// TODO: move to file
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
      builder: (BuildContext context, Widget? widget) {
        Widget error = Text('...rendering error...');
        if (widget is Scaffold || widget is Navigator)
          error = Scaffold(body: Center(child: error));
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
        return widget ?? Container();
      },
    );
  }
}
