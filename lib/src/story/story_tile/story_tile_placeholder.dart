import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import '../../widget/loading_placeholder.dart';
import 'story_tile_padding.dart';

class StoryTilePlaceholder extends StatelessWidget {
  const StoryTilePlaceholder({Key? key, required this.showLeading})
      : super(key: key);

  final bool showLeading;

  @override
  Widget build(BuildContext context) {
    return StoryTilePadding(child: LoadingPlaceholder());

    // // TODO: extract to placeholder.dart
    // final textStyle = TextStyle(
    //   color: Colors.white,
    //   backgroundColor: Colors.white,
    // );

    // // extract to placeholder.dart
    // return Shimmer.fromColors(
    //   baseColor: Colors.grey[300]!,
    //   highlightColor: Colors.grey[100]!,
    //   child: Padding(
    //     padding:
    //         EdgeInsets.only(top: storyTilePadding, bottom: storyTilePadding),
    //     child: ListTile(
    //       contentPadding: EdgeInsets.all(0),
    //       leading: showLeading ? Text('   ', style: textStyle) : null,
    //       title: Text('_' * 60, style: textStyle),
    //       subtitle: Text('_' * 40, style: textStyle),
    //     ),
    //   ),
    // );
  }
}
