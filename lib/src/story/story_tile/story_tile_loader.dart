import 'package:flutter/material.dart';
// import 'package:flutter_hacker_news_prototype/src/widget/loader.dart';

import 'package:provider/provider.dart';

import '../../hacker_news_api/item.dart';
import '../../notifier/item_notifier.dart';
import '../../widget/result_builder.dart';
import 'story_tile.dart';
import 'story_tile_placeholder.dart';

class StoryTileLoader extends StatelessWidget {
  const StoryTileLoader({
    Key? key,
    required this.id,
    required this.onData,
    this.showLeading = true,
  }) : super(key: key);

  final int id;
  final Widget Function(BuildContext, Item) onData;
  final bool showLeading;

  // @override
  // Widget build(BuildContext context) {
  //   return Loader(
  //     load: (context) => context.read<ItemNotifier>().loadItem(id),
  //     builder: builder,
  //   );
  // }

  // Widget builder(BuildContext context) {
  //   final item = context.select<ItemNotifier, ItemResult>((v) => v.item(id));

  //   final error = item.error;
  //   if (error != null) {
  //     return onError(context, error);
  //   }

  //   final value = item.value;
  //   if (value != null) {
  //     return onData(context, value);
  //   }

  //   return onLoading(context);
  // }

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
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return StoryTilePlaceholder(showLeading: showLeading);
  }
}
