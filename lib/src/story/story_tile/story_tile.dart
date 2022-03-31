import 'package:flutter/material.dart';

import '../../hacker_news_api/item.dart';
import '../../story/story_screen.dart';
import '../../widget/link.dart';
import '../../user/user_screen.dart';
import '../format_time.dart';
import 'style.dart';

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
    return Padding(
      padding: storyTilePadding,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: showLeading ? Text('$rank.') : null,
        title: Wrap(
          children: [
            MaterialAppLink(
              child: Text(
                item.title ?? '[deleted]',
                style: TextStyle(fontSize: 16),
              ),
              routeBuilder: (_) => StoryScreen(id: item.id),
              active: activeCommentsLink,
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
            Text('${item.descendants ?? 0} comments'),
          ],
        ),
        trailing: Column(
          children: [
            if (item.url != null)
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: WebLink(
                  child: Icon(Icons.open_in_new, size: 35),
                  url: item.url!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
