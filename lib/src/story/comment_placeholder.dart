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
import 'comment.dart';
import 'const.dart';
import 'format_time.dart';
import 'story_screen.dart';

class CommentPlaceholder extends StatelessWidget {
  CommentPlaceholder({Key? key, required this.depth}) : super(key: key);

  final int depth;

  @override
  Widget build(BuildContext context) {
    final leftPadding = min(depth, commentMaxDepth) * 30.0;
    final textStyle = TextStyle(
      color: Colors.white,
      backgroundColor: Colors.white,
    );

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.only(
          left: leftPadding,
          top: commentPadding,
          bottom: commentPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('_' * 40, style: textStyle),
            // SizedBox(height: 5),
            Text('_' * 250, style: textStyle),
            // Container(
            // height: 26.0,
            // color: Colors.white,
            // ),
            // SizedBox(height: 10,),
            // Container(
            // height: 48.0,
            // color: Colors.white,
            // ),
          ],
        ),
      ),
    );
  }
}

// class CommentsPlaceholder extends StatelessWidget {
//   CommentsPlaceholder({Key? key, this.limit = 20}) : super(key: key);

//   final int limit;

//   @override
//   Widget build(BuildContext context) {
//     return ListView(children: [
//       for (int i = 0; i < 20; i++) CommentPlaceholder(depth: 0),
//     ]);
//   }
// }
