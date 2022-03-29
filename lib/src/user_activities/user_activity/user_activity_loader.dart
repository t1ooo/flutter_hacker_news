import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../hacker_news_api/item.dart';
import '../../notifier/item_notifier.dart';
import '../../story/comment/comment.dart';
import '../../story/comment/comment_placeholder.dart';
import '../../story/story_tile/story_tile.dart';
// import '../../widget/loader.dart';
import '../../widget/result_builder.dart';

class UserActivityLoader extends StatelessWidget {
  const UserActivityLoader({Key? key, required this.id}) : super(key: key);

  final int id;

  // @override
  // Widget build(BuildContext context) {
  //   return Loader(
  //     load: (context) => context.read<ItemNotifier>().loadItem(id),
  //     builder: builder,
  //   );
  // }

  // Widget builder(BuildContext context) {
  //   final activityR =
  //       context.select<ItemNotifier, ItemResult>((v) => v.item(id));

  //   final error = activityR.error;
  //   if (error != null) {
  //     return onError(context, error);
  //   }

  //   final value = activityR.value;
  //   if (value != null) {
  //     return onData(context, value);
  //   }

  //   return onLoading(context);
  // }

  @override
  Widget build(BuildContext context) {
    return ResultBuilder(
      load: (context) => context.read<ItemNotifier>().loadItem(id),
      result: (context) =>
          context.select<ItemNotifier, ItemResult>((v) => v.item(id)),
      onError: onError,
      onData: onData,
      onLoading: onLoading,
    );
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return CommentPlaceholder();
  }

  Widget onData(BuildContext context, Item item) {
    if (item.type == 'comment') {
      return Comment(
        item: item,
        showNested: false,
        activeUserLink: false,
        collapsable: false,
        showParentLink: true,
      );
    } else if (item.type == 'story') {
      return StoryTile(
        item: item,
        showLeading: false,
        activeUserLink: false,
      );
    } else {
      print(item.toJson);
      return StoryTile(
        item: item,
        showLeading: false,
        activeUserLink: false,
      );
    }
  }
}
