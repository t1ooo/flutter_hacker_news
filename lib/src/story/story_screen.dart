import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../hacker_news_api/hacker_news_api.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/item_notifier.dart';
import '../provider/provider.dart';
import '../style/style.dart';
import 'story_loader.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story'),
      ),
      body: Padding(
        padding: pagePadding,
        child: MultiProvider(
          providers: [
            itemProvider(context),
            commentProvider(context),
          ],
          child: StoryLoader(id: id),
        ),
      ),
    );
  }
}
