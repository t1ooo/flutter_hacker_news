import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/hacker_news_api.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/item_notifier.dart';
import '../notifier/user_notifier.dart';
import '../style/style.dart';
import 'user_activities_loader.dart';

class UserActivitiesScreen extends StatelessWidget {
  const UserActivitiesScreen({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Activity'),
      ),
      body: Padding(
        padding: pagePadding,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (BuildContext context) =>
                  UserNotifier(context.read<HackerNewsApi>()),
            ),
            ChangeNotifierProvider(
              create: (BuildContext context) => ItemNotifier(
                context.read<HackerNewsApi>(),
              ),
            ),
            ChangeNotifierProvider(
              create: (BuildContext context) => CommentNotifier(),
            ),
          ],
          child: UserActivitiesLoader(name: name),
        ),
      ),
    );
  }
}
