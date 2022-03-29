import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../story/story_tile_placeholder.dart';

class StoriesPlaceholder extends StatelessWidget {
  const StoriesPlaceholder({Key? key, this.limit = 20}) : super(key: key);

  final int limit;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      for (int i = 0; i < limit; i++) StoryTilePlaceholder(showLeading: true),
    ]);
  }
}
