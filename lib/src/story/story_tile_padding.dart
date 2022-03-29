import 'package:flutter/material.dart';

import '../hacker_news_api/item.dart';
import '../story/story_screen.dart';
import '../widget/link.dart';
import '../user/user_screen.dart';
import 'const.dart';
import 'format_time.dart';

class StoryTilePadding extends StatelessWidget {
  const StoryTilePadding({Key? key, required this.child}) : super(key: key);

  final Widget child;
  static const _storyTilePadding = 10.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _storyTilePadding),
      child: child,
    );
  }
}
