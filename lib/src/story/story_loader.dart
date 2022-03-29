import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../hacker_news_api/item.dart';
import '../notifier/item_notifier.dart';
import '../ui/builder.dart._';
import '../ui/swipe_to_refresh.dart';
import 'comments_placeholder.dart';
import 'story.dart';

class StoryLoader extends StatelessWidget {
  const StoryLoader({Key? key, required this.id, this.onData}) : super(key: key);

  final int id;
  final Widget Function(BuildContext, Item)? onData;

  @override
  Widget build(BuildContext context) {
    return InitBuilder(
      initState: () => context.read<ItemNotifier>().loadItem(id),
      builder: builder,
    );
  }

  Widget builder(BuildContext context) {
    final storyR = context.select<ItemNotifier, ItemResult>((v) => v.item(id));

    final error = storyR.error;
    if (error != null) {
      return onError(context, error);
    }

    final value = storyR.value;
    if (value != null) {
      return _onData(context, value);
    }

    return onLoading(context);
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(e.toString());
  }

  Widget onLoading(BuildContext context) {
    return CommentsPlaceholder();
  }

  // Widget build(BuildContext context) {
  Widget _onData(BuildContext context, Item item) {
    return SwipeToRefresh(
      onRefresh: () async {
        context.read<ItemNotifier>().reloadItems();
      },
      child: (onData ?? defaultOnData)(context, item),
    );
  }

  Widget defaultOnData(BuildContext context, Item item) {
    return Story(item: item);
  }
}
