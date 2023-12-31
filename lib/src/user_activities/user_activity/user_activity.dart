import 'package:flutter/material.dart';

import '../../hacker_news_api/item.dart';
import '../../story/comment/comment.dart';
import '../../story/story_tile/story_tile.dart';

class UserActivity extends StatelessWidget {
  const UserActivity({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    if (item.type == 'comment') {
      return Comment(
        item: item,
        showNested: false,
        activeUserLink: false,
        collapsible: false,
        showParentLink: true,
      );
    } else {
      return StoryTile(
        item: item,
        showLeading: false,
        activeUserLink: false,
      );
    }
  }
}
