import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/item.dart';
import '../notifier/item_notifier.dart';
import '../widget/result_builder.dart';
import '../widget/swipe_to_refresh.dart';
import 'comment/comment_placeholder.dart';
import 'story.dart';

class StoryLoader extends StatelessWidget {
  const StoryLoader({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return ResultBuilder(
      result: (context) {
        context.read<ItemNotifier>().loadItem(id);
        return context.select<ItemNotifier, ItemResult>((v) => v.item(id));
      },
      onError: onError,
      onData: onData,
      onLoading: onLoading,
    );
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(e.toString());
  }

  Widget onLoading(BuildContext context) {
    return ListView(
      children: [for (int i = 0; i < 20; i++) CommentPlaceholder()],
    );
  }

  Widget onData(BuildContext context, Item item) {
    return SwipeToRefresh(
      onRefresh: () async {
        await context.read<ItemNotifier>().reloadItems();
      },
      child: Story(item: item),
    );
  }
}
