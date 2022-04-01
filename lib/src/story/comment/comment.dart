import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../hacker_news_api/item.dart';
import '../../notifier/comment_notifier.dart';
import '../../user/user_screen.dart';
import '../../widget/html.dart';
import '../../widget/link.dart';
import '../format_time.dart';
import '../story_screen.dart';
import 'comment_loader.dart';
import 'style.dart';

class Comment extends StatelessWidget {
  const Comment({
    Key? key,
    required this.item,
    this.showNested = true,
    this.depth = 0,
    this.activeUserLink = true,
    this.collapsible = true,
    this.showParentLink = false,
  }) : super(key: key);

  final Item item;
  final bool showNested;
  final int depth;
  final bool activeUserLink;
  final bool collapsible;
  final bool showParentLink;

  @override
  Widget build(BuildContext context) {
    final isVisible =
        context.select<CommentNotifier, bool>((v) => v.isVisible(item.id));

    final textStyle = TextStyle(color: Colors.grey);

    return Padding(
      padding: commentPadding(depth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              if (item.by != null) ...[
                MaterialAppLink(
                  routeBuilder: (_) => UserScreen(name: item.by!),
                  active: activeUserLink,
                  child: Text(item.by!, style: textStyle),
                ),
                Text(' '),
              ],
              if (item.time != null) ...[
                Text(formatItemTime(item.time!), style: textStyle),
                Text(' '),
              ],
              if (showParentLink && item.parent != null && depth == 0) ...[
                Text('| ', style: textStyle),
                MaterialAppLink(
                  child: Text('parent', style: textStyle),
                  routeBuilder: (_) => StoryScreen(id: item.parent!),
                ),
                Text(' '),
              ],
              if (collapsible) ...[
                InkWell(
                  child: Text(isVisible ? '[-]' : '[+]', style: textStyle),
                  onTap: () =>
                      context.read<CommentNotifier>().toggleVisibility(item.id),
                ),
              ]
            ],
          ),
          if (isVisible) ...[
            if (item.text != null)
              HtmlText(html: item.text!)
            else
              Text('[deleted]'),
            // --------------------------------
            if (showNested && item.kids != null)
              ListView.builder(
                shrinkWrap: true,
                itemCount: item.kids!.length,
                itemBuilder: (_, int i) {
                  final id = item.kids![i];
                  return CommentLoader(
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
