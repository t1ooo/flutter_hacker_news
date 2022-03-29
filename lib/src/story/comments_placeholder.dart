import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';

import '../hacker_news_api/item.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/item_notifier.dart';
import '../ui/builder.dart._';
import '../ui/html.dart';
import '../ui/link.dart';
import '../user/user_screen.dart';
import 'comment_placeholder.dart';
import 'format_time.dart';
import 'story_screen.dart';


class CommentsPlaceholder extends StatelessWidget {
  CommentsPlaceholder({Key? key, this.limit = 20}) : super(key: key);

  final int limit;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      for (int i = 0; i < 20; i++) CommentPlaceholder(depth: 0),
    ]);
  }
}
