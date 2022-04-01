import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'logger.dart';
import 'src/app.dart';
import 'src/provider/provider.dart';

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
