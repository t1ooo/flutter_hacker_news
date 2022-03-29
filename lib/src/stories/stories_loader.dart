import 'package:flutter/material.dart';
import 'package:flutter_hacker_news_prototype/src/story/loading_placeholder.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/story_type.dart';
import '../notifier/item_notifier.dart';
import '../notifier/story_notifier.dart';
import '../story/story_tile_placeholder.dart';
import '../widget/loader.dart';
import '../widget/swipe_to_refresh.dart';
import 'stories.dart';
import 'stories_placeholder.dart';

class StoriesLoader extends StatelessWidget {
  const StoriesLoader({
    Key? key,
    required this.storyType,
    this.onData,
  }) : super(key: key);

  final StoryType storyType;
  final Widget Function(BuildContext, List<int>)? onData;

  @override
  Widget build(BuildContext context) {
    return Loader(
      load: (context) => context.read<StoryNotifier>().loadStoryIds(storyType),
      builder: builder,
    );
  }

  Widget builder(BuildContext context) {
    final storyIdsR =
        context.select<StoryNotifier, StoryIdsResult>((v) => v.storyIds);

    final error = storyIdsR.error;
    if (error != null) {
      return onError(context, error);
    }

    final storyIds = storyIdsR.value;
    if (storyIds != null) {
      return _onData(context, storyIds);
    }

    return onLoading(context);
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return StoriesPlaceholder();
  }

  Widget _onData(BuildContext context, List<int> storyIds) {
    return SwipeToRefresh(
      onRefresh: () async {
        await context.read<StoryNotifier>().reloadStoryIds(storyType);
        await context.read<ItemNotifier>().reloadItems();
      },
      child: (onData ?? defaultOnData)(context, storyIds),
    );
  }

  Widget defaultOnData(context, List<int> storyIds) {
    return Stories(storyIds: storyIds);
  }
}
