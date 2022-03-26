import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';


import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/item.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/item_notifier.dart';
import 'story.dart';
import 'story_tile.dart';
import '../style/style.dart';
import 'comment.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StoryScreen'),
      ),
      body: Padding(
        padding: pagePadding,
        // child: Story(id: id),
        // child: ChangeNotifierProvider(
        //   create: (BuildContext context) =>
        //       ItemNotifier(context.read<HackerNewsApi>())..loadItem(id),
        //   child: Story(id: id),
        // ),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (BuildContext context) =>
                  ItemNotifier(context.read<HackerNewsApi>())..loadItem(id),
            ),
            ChangeNotifierProvider(
              create: (BuildContext context) => CommentNotifier(),
            ),
          ],
          child: Story(id: id),
        ),
      ),
    );
  }
}
