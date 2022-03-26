import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';

import '../hacker_news_api.dart';
import 'stories_controller.dart';
import 'story_tile.dart';

class Stories extends StatelessWidget {
  Stories({Key? key, required this.storyType}) : super(key: key);

  final StoryType storyType;

  // final hnNotifier = locator<HackerNewsNotifier>()..loadBeststories();

  @override
  Widget build(BuildContext context) {
    // final controller = context.watch<StoriesController>();
    final storyIdsR =
        context.select<StoriesController, StoryIdsResult>((v) => v.storyIds);

    // final storyIds = controller.storyIds;

    final error = storyIdsR.error;
    if (error != null) {
      return onError(context, error);
    }

    final storyIds = storyIdsR.value;
    if (storyIds != null) {
      return onData(context, storyIds, 1);
    }

    return onLoading(context);
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (_, __) {
        return StoryTilePlaceholder(showLeading: true);
      },
    );
  }

  Widget onData(BuildContext context, List<int> storyIds, int rank) {
    // return ListView(
    //   children: [
    //     // for (final id in data)  StoryTile(id: id, rank: rank)
    //     for (int i = 0; i < data.length; i++)
    //       StoryTileLoader(id: data[i], rank: rank + i)
    //   ],
    // );

    // print(storyIds);
    return ListView.builder(
      itemCount: storyIds.length,
      itemBuilder: (_, int i) {
        final id = storyIds[i];
        // print(id);
        context.read<StoriesController>().loadItem(id);
        return StoryTileLoader(id: id, rank: rank + i);
      },
    );
  }
}
