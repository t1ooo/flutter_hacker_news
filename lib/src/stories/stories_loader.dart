import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/story_type.dart';
import '../notifier/item_notifier.dart';
import '../notifier/story_notifier.dart';
import '../story/story_tile.dart';
import '../ui/loader.dart';
import '../ui/swipe_to_refresh.dart';
import 'stories.dart';

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
      load: () => context.read<StoryNotifier>().loadStoryIds(storyType),
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
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (_, __) {
        return StoryTilePlaceholder(showLeading: true);
      },
    );
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
