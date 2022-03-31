import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../hacker_news_api/item.dart';
import '../../notifier/item_notifier.dart';

import '../../widget/result_builder.dart';

import 'comment_placeholder.dart';

class CommentLoader extends StatelessWidget {
  const CommentLoader({
    Key? key,
    required this.id,
    required this.onData,
    this.depth = 0,
  }) : super(key: key);

  final int id;
  final int depth;
  final Widget Function(BuildContext, Item) onData;

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
    return CommentPlaceholder(depth: depth);
  }
}
