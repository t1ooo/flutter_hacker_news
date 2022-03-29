import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/item.dart';
import '../notifier/item_notifier.dart';
import '../widget/loader.dart';
import 'comment.dart';
import 'comment_placeholder.dart';

class CommentLoader extends StatelessWidget {
  const CommentLoader({
    Key? key,
    required this.id,
    this.showNested = true,
    this.depth = 0,
    this.activeUserLink = true,
    this.collapsable = true,
  }) : super(key: key);

  final int id;
  final int depth;
  final bool showNested;
  final bool activeUserLink;
  final bool collapsable;

  @override
  Widget build(BuildContext context) {
    final commentR =
        context.select<ItemNotifier, ItemResult>((v) => v.item(id));

    final error = commentR.error;
    if (error != null) {
      return onError(context, error);
    }

    final value = commentR.value;
    if (value != null) {
      return onData(context, value);
    }

    return onLoading(context);
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return CommentPlaceholder(depth: depth);
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, Item item) {
    return Comment(
      item: item,
      showNested: showNested,
      depth: depth,
      activeUserLink: activeUserLink,
      collapsable: collapsable,
    );
  }
}

class CommentLoaderV2 extends StatelessWidget {
  const CommentLoaderV2({
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
    return Loader(
      load: (context) => context.read<ItemNotifier>().loadItem(id),
      builder: builder,
    );
  }

  Widget builder(BuildContext context) {
    final commentR =
        context.select<ItemNotifier, ItemResult>((v) => v.item(id));

    final error = commentR.error;
    if (error != null) {
      return onError(context, error);
    }

    // final value = commentR.value;
    // if (value != null) {
    //   return onData(context, value);
    // }

    return onLoading(context);
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return CommentPlaceholder(depth: depth);
  }
}
