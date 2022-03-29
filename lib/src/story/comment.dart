import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/item.dart';
import '../notifier/comment_notifier.dart';
import '../ui/html.dart';
import '../ui/link.dart';
import '../user/user_screen.dart';
import 'comment_loader.dart';
import 'const.dart';
import 'format_time.dart';
import 'story_screen.dart';

class Comment extends StatelessWidget {
  const Comment({
    Key? key,
    required this.item,
    this.showNested = true,
    this.depth = 0,
    this.activeUserLink = true,
    this.collapsable = true,
    this.showParentLink = false,
  }) : super(key: key);

  final Item item;
  final bool showNested;
  final int depth;
  final bool activeUserLink;
  final bool collapsable;
  final bool showParentLink;

  @override
  Widget build(BuildContext context) {
    final isVisible =
        context.select<CommentNotifier, bool>((v) => v.isVisible(item.id));

    final leftPadding = min(depth, commentMaxDepth) * 30.0;
    final textStyle = TextStyle(color: Colors.grey);

    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        top: commentPadding,
        bottom: commentPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              if (item.by != null) ...[
                MaterialAppLink(
                  child: Text(item.by!, style: textStyle),
                  routeBuilder: (_) => UserScreen(name: item.by!),
                  active: activeUserLink,
                ),
              ],
              if (item.time != null) ...[
                Text(' ${formatItemTime(item.time!)}', style: textStyle),
              ],
              if (showParentLink && item.parent != null && depth == 0) ...[
                Text(' | ', style: textStyle),
                MaterialAppLink(
                  child: Text('parent', style: textStyle),
                  // child: Text('comments'),
                  routeBuilder: (_) => StoryScreen(id: item.parent!),
                ),
              ],
              if (collapsable) ...[
                Text(' '),
                InkWell(
                  child: Text(isVisible ? '[-]' : '[+]', style: textStyle),
                  onTap: () =>
                      context.read<CommentNotifier>().toggleVisibility(item.id),
                ),
              ]
            ],
          ),
          if (isVisible) ...[
            if (item.text != null) ...[
              HtmlText(html: item.text!),
            ],
            if (showNested && item.kids != null)
              ListView.builder(
                shrinkWrap: true,
                itemCount: item.kids!.length,
                itemBuilder: (_, int i) {
                  final id = item.kids![i];
                  return CommentLoaderV2(
                    id: id,
                    depth: depth + 1,
                    onData: (_, Item item) {
                      return Comment(
                        item: item,
                        depth: depth + 1,
                        activeUserLink: activeUserLink,
                      );
                    },
                  );
                },
              ),
          ],
        ],
      ),
    );
  }
}
