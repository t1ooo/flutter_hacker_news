import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';

import '../hacker_news_notifier.dart';
import '../item.dart';
import 'html.dart';
import 'user.dart';
import 'load_indicator.dart';

const commentMaxDepth = 5;

class CommentLoader extends StatelessWidget {
  CommentLoader({
    Key? key,
    required this.id,
    this.showNested = true,
    this.depth = 0,
  }) : super(key: key);

  final int id;
  final int depth;
  final bool showNested;

  @override
  Widget build(BuildContext context) {
    // return CommentPlaceholder();
    final notifier = context.watch<HackerNewsNotifier>();

    return FutureBuilder(
      future: notifier.item(id),
      builder: (BuildContext _, AsyncSnapshot<Item> snap) {
        final error = snap.error;
        if (error != null) {
          onError(context, error);
        }

        final data = snap.data;
        if (data != null) {
          return onData(context, data);
        }

        return onLoading(context);
      },
    );
  }

  void onError(BuildContext context, Object? error) {
    // TODO
  }

  Widget onLoading(BuildContext context) {
    // return LoadIndicator();
    return CommentPlaceholder(depth: depth);
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, Item item) {
    return Comment(
      item: item,
      showNested: showNested,
      depth: depth,
    );
  }
}

class Comment extends StatelessWidget {
  Comment({
    Key? key,
    required this.item,
    this.showNested = true,
    this.depth = 0,
  }) : super(key: key);

  final Item item;
  final bool showNested;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final leftPadding = min(depth, commentMaxDepth) * 30.0;
    final textStyle = TextStyle(color: Colors.grey);

    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: 5, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              if (item.by != null) ...[
                InkWell(
                  child: Text(item.by!, style: textStyle),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserScreen(name: item.by!),
                      ),
                    );
                  },
                ),
              ],
              if (item.time != null) ...[
                Text(' '),
                Text(' ${formatItemTime(item.time!)}', style: textStyle),
                Text(' | '),
              ],
              Text('prev', style: textStyle),
              Text(' | ', style: textStyle),
              Text('next [–]', style: textStyle),
            ],
          ),
          if (item.text != null) ...[
            // TODO: bug:
            //  exception when fast scroll with mouse
            //  bug reproduced on user activity
            // Html(
            //   data: item.text!,
            //   style: {
            //     "body": Style(
            //       padding: EdgeInsets.zero,
            //       margin: EdgeInsets.zero,
            //     ),
            //   },
            //   shrinkWrap: true,
            // ),
            HtmlText(html: item.text!),
          ],
          if (showNested && item.kids != null)
            for (final id in item.kids!) CommentLoader(id: id, depth: depth + 1)
        ],
      ),
    );
  }
}

// class CommentBorder extends StatelessWidget {
//   const CommentBorder({Key? key, required this.child}) : super(key: key);

//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         border: Border(
//           left: BorderSide(width: 1.0, color: Color.fromARGB(255, 0, 0, 0)),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 10),
//         child: child,
//       ),
//     );
//   }
// }

/* Expanded(
    //     child: Shimmer.fromColors( */

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

    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: 5, bottom: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
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

// TODO: remove duplicate
String formatItemTime(int unixTimeS) {
  final diff = DateTime.now()
      .toUtc()
      .difference(DateTime.fromMillisecondsSinceEpoch(unixTimeS * 1000));
  if (diff.inDays > 0) {
    return '${diff.inDays} days ago';
  }
  if (diff.inHours > 0) {
    return '${diff.inHours} hours ago';
  }

  return '${diff.inMinutes} minutes ago';
}
