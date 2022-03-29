import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/hacker_news_api.dart';
import '../style/style.dart';
import '../notifier/user_notifier.dart';
import 'user_loader.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
      ),
      body: Padding(
        padding: pagePadding,
        child: ChangeNotifierProvider(
          create: (BuildContext context) =>
              UserNotifier(context.read<HackerNewsApi>()),
          child: UserLoader(name: name),
        ),
      ),
    );
  }
}
