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
      // if ((item.text ?? '') == '') {
      //   print(item.toJson());
      // }
      return Comment(
        item: item,
        showNested: false,
        activeUserLink: false,
        collapsable: false,
        showParentLink: true,
      );
    } else if (item.type == 'story') {
      // if ((item.title ?? '') == '') {
      //   print(item.toJson());
      // }
      return StoryTile(
        item: item,
        showLeading: false,
        activeUserLink: false,
      );
    } else {
      print(item.toJson());
      // return Container();
      // return Text(item.toJson().toString());
      // print(item.title);
      return StoryTile(
        item: item,
        showLeading: false,
        activeUserLink: false,
      );
    }
  }
}
