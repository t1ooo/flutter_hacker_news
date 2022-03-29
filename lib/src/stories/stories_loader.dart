import 'package:flutter/material.dart';
import 'package:flutter_hacker_news_prototype/src/widget/loading_placeholder.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/story_type.dart';
import '../notifier/item_notifier.dart';
import '../notifier/result.dart';
import '../notifier/story_notifier.dart';
import '../story/story_tile/story_tile_placeholder.dart';
import '../widget/result_builder.dart';
import '../widget/swipe_to_refresh.dart';
import 'stories.dart';

class StoriesLoader extends StatelessWidget {
  const StoriesLoader({Key? key, required this.storyType}) : super(key: key);

  final StoryType storyType;

  // @override
  // Widget build(BuildContext context) {
  //   return Loader(
  //     load: (context) => context.read<StoryNotifier>().loadStoryIds(storyType),
  //     builder: builder,
  //   );
  // }

  // Widget builder(BuildContext context) {
  //   final storyIdsR =
  //       context.select<StoryNotifier, StoryIdsResult>((v) => v.storyIds);

  //   final error = storyIdsR.error;
  //   if (error != null) {
  //     return onError(context, error);
  //   }

  //   final storyIds = storyIdsR.value;
  //   if (storyIds != null) {
  //     return onData(context, storyIds);
  //   }

  //   return onLoading(context);
  // }

  @override
  Widget build(BuildContext context) {
    return ResultBuilder(
      result: (context) {
        context.read<StoryNotifier>().loadStoryIds(storyType);
        return context.select<StoryNotifier, StoryIdsResult>((v) => v.storyIds);
      },
      onError: onError,
      onData: onData,
      onLoading: onLoading,
    );
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return ListView(children: [
      for (int i = 0; i < 20; i++) StoryTilePlaceholder()
    ]);
    
  }

  Widget onData(BuildContext context, List<int> storyIds) {
    return SwipeToRefresh(
      onRefresh: () async {
        await context.read<StoryNotifier>().reloadStoryIds(storyType);
        await context.read<ItemNotifier>().reloadItems();
      },
      child: Stories(storyIds: storyIds),
    );
  }
}
