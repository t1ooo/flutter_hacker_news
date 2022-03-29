import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';

import '../hacker_news_api/item.dart';
import '../hacker_news_api/story_type.dart';
import '../notifier/item_notifier.dart';
import '../notifier/story_notifier.dart';
import '../story/story_tile.dart';
import '../notifier/user_notifier.dart';
import '../ui/builder.dart._';
import '../ui/loader.dart';
import '../ui/swipe_to_refresh.dart';
import 'stories.dart';
// import 'story_tile.dart._';

class StoriesLoader extends StatelessWidget {
  StoriesLoader({Key? key, required this.storyType, this.onData})
      : super(key: key);

  final StoryType storyType;
  final Widget Function(BuildContext, List<int>)? onData;

  @override
  Widget build(BuildContext context) {
    return Loader(
      load: () => context.read<StoryNotifier>().loadStoryIds(storyType),
      builder: builder,
    );

    // return FutureBuilder(
    //   future: context.read<ItemNotifier>().loadItem(id),
    //   builder: (BuildContext context, _ ) => builder(context),
    // );

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   context.read<StoryNotifier>().loadStoryIds(storyType);
    // });
    // return builder(context);
  }

  Widget builder(BuildContext context) {
    // final controller = context.watch<StoriesController>();
    final storyIdsR =
        context.select<StoryNotifier, StoryIdsResult>((v) => v.storyIds);

    // final storyIds = controller.storyIds;

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
