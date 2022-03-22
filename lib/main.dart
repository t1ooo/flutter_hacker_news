import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'logger.dart';
import 'src/ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureLogger(kDebugMode);
  runApp(const MyApp());
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
