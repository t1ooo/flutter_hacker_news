import 'package:flutter/material.dart';

import '../hacker_news_api/item.dart';
import '../story/story_screen.dart';
import '../widget/link.dart';
import '../user/user_screen.dart';
import 'const.dart';
import 'format_time.dart';

class StoryTile extends StatelessWidget {
  const StoryTile({
    Key? key,
    required this.item,
    this.rank = 0,
    this.showLeading = true,
    this.activeCommentsLink = true,
    this.activeUserLink = true,
  }) : super(key: key);

  final Item item;
  final int rank;
  final bool showLeading;
  final bool activeCommentsLink;
  final bool activeUserLink;

  @override
  Widget build(BuildContext context) {
    final title = (item.deleted == true) ? '[deleted]' : (item.title ?? '');

    return Padding(
      padding: EdgeInsets.only(top: storyTilePadding, bottom: storyTilePadding),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: showLeading ? Text('$rank.') : null,
        title: Wrap(
          children: [
            if (item.url != null)
              WebLink(
                child: Text(title, textScaleFactor: 1.6),
                url: item.url!,
              )
            else
              MaterialAppLink(
                child: Text(title, textScaleFactor: 1.6),
                routeBuilder: (_) => StoryScreen(id: item.id),
              ),
          ],
        ),
        subtitle: Wrap(
          children: [
            if (item.score != null) ...[
              Text('${item.score} points '),
            ],
            if (item.by != null) ...[
              Text('by '),
              MaterialAppLink(
                child: Text(item.by!),
                routeBuilder: (_) => UserScreen(name: item.by!),
                active: activeUserLink,
              ),
              Text(' '),
            ],
            if (item.time != null) ...[
              Text(formatItemTime(item.time!) + ' | '),
            ],
            MaterialAppLink(
              child: Text('${item.descendants ?? 0} comments'),
              routeBuilder: (_) => StoryScreen(id: item.id),
              active: activeCommentsLink,
            ),
          ],
        ),
      ),
    );
  }
}
