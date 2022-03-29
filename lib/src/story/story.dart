import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/item.dart';
import '../notifier/item_notifier.dart';
import '../widget/swipe_to_refresh.dart';
import 'comment/comment_loader.dart';
import 'comment/comment.dart';
import 'story_tile/story_tile.dart';

class Story extends StatelessWidget {
  const Story({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return SwipeToRefresh(
      onRefresh: () async {
        context.read<ItemNotifier>().reloadItems();
      },
      child: ListView(
        children: [
          StoryTile(
            item: item,
            rank: 0,
            showLeading: false,
            activeCommentsLink: false,
          ),
          SizedBox(height: 20),
          if (item.kids != null)
            for (var id in item.kids!)
              CommentLoaderV2(
                id: id,
                onData: (_, Item item) {
                  return Comment(
                    item: item,
                  );
                },
              )
        ],
      ),
    );
  }
}
