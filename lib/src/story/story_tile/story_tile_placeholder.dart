import 'package:flutter/material.dart';

import '../../widget/loading_placeholder.dart';
import 'style.dart';

class StoryTilePlaceholder extends StatelessWidget {
  const StoryTilePlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: storyTilePadding,
      child: LoadingPlaceholder(),
    );
  }
}
