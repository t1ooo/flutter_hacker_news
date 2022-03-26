import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';

// import '../hacker_news_notifier.dart';
import '../item.dart';
import '../item_notifier.dart';
import '../ui/html.dart';


const commentMaxDepth = 5;

class CommentLoader extends StatelessWidget {
  CommentLoader({
    Key? key,
    required this.id,
    this.showNested = true,
    this.depth = 0,
    this.activeUserLink = true,
  }) : super(key: key);

  final int id;
  final int depth;
  final bool showNested;
  final bool activeUserLink;

  @override
  Widget build(BuildContext context) {
    // return CommentPlaceholder();
    // final notifier = context.watch<HackerNewsNotifier>();

    final commentR =
        context.select<ItemNotifier, ItemResult>((v) => v.item(id));

    final error = commentR.error;
    if (error != null) {
      return onError(context, error);
    }

    final value = commentR.value;
    if (value != null) {
      return onData(context, value);
    }

    return onLoading(context);
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return CommentPlaceholder(depth: depth);
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, Item item) {
    return Comment(
      item: item,
      showNested: showNested,
      depth: depth,
      activeUserLink: activeUserLink,
    );
  }
}

// class CommentController extends ChangeNotifier {
//   CommentController() {
//     print('CommentController');
//   }

//   @override
//   void dispose() {
//     print('CommentController dispose');
//     super.dispose();
//   }

//   bool _isVisible = true;

//   bool get isVisible => _isVisible;

//   void toggleVisibility() {
//     _isVisible = !_isVisible;
//     notifyListeners();
//   }

//   // void show() {
//   //   _show = false;
//   //   notifyListeners();
//   // }

//   // void hide() {
//   //   _show = true;
//   //   notifyListeners();
//   // }
// }

const _commentPadding = 10.0;

class Comment extends StatelessWidget {
  Comment({
    Key? key,
    required this.item,
    this.showNested = true,
    this.depth = 0,
    this.activeUserLink = true,
  }) : super(key: key);

  final Item item;
  final bool showNested;
  final int depth;
  final bool activeUserLink;

  @override
  Widget build(BuildContext context) {
    final isVisible = context
        .select<ItemNotifier, bool>((v) => v.isVisible(item.id));

    final leftPadding = min(depth, commentMaxDepth) * 30.0;
    final textStyle = TextStyle(color: Colors.grey);

    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        top: _commentPadding,
        bottom: _commentPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              if (item.by != null) ...[
                InkWell(
                  child: Text(item.by!, style: textStyle),
                  onTap: activeUserLink
                      ? () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => UserScreen(name: item.by!),
                          //   ),
                          // );
                        }
                      : null,
                ),
              ],
              if (item.time != null) ...[
                Text(' '),
                Text(' ${formatItemTime(item.time!)}', style: textStyle),
                // Text(' | '),
              ],
              // Text('prev', style: textStyle),
              // Text(' | ', style: textStyle),
              // Text('next', style: textStyle),
              // Text(' [–]', style: textStyle),
              Text(' '),

              InkWell(
                child: Text(isVisible ? '[-]' : '[+]', style: textStyle),
                onTap: () => context
                    .read<ItemNotifier>()
                    .toggleVisibility(item.id),
              ),
            ],
          ),
          if (isVisible) ...[
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
              ListView.builder(
                shrinkWrap: true,
                itemCount: item.kids!.length,
                itemBuilder: (_, int i) {
                  final id = item.kids![i];
                  context.read<ItemNotifier>().loadItem(id);
                  return CommentLoader(
                    id: id,
                    depth: depth + 1,
                    activeUserLink: activeUserLink,
                  );
                },
              ),
          ],
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
          top: _commentPadding,
          bottom: _commentPadding,
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
