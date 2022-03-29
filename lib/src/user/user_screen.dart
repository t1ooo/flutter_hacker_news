import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

// import '../hacker_news_notifier.dart';

import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/user.dart';
import '../story/comment.dart';
import '../style/style.dart';
import '../ui/html.dart';
import '../ui/link.dart';
import '../user_activity/user_activity_screen_v2.dart';
import '../notifier/user_notifier.dart';
import 'user_loader.dart';

class UserScreen extends StatelessWidget {
  UserScreen({Key? key, required this.name}) : super(key: key);

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
              UserNotifier(context.read<HackerNewsApi>()),//..loadUser(name),
          child: UserLoader(name: name),
        ),
      ),
    );
  }
}
