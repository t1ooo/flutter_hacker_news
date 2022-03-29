import 'package:flutter/material.dart';

import '../hacker_news_api/item.dart';
import '../story/story_tile.dart';
import '../story/story_tile_loader.dart';

class Stories extends StatelessWidget {
  const Stories({
    Key? key,
    required this.storyIds,
  }) : super(key: key);

  final List<int> storyIds;

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: storyIds.length,
      itemBuilder: (_, int i) {
        final id = storyIds[i];
        return StoryTileLoaderV2(
          // TODO: remove V1
          id: id,
          onData: (_, Item item) {
            return StoryTile(item: item, rank: i + 1);
          },
        );
      },
    );
  }
}
