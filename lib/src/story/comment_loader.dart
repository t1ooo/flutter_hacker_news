import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';

import '../hacker_news_api/item.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/item_notifier.dart';
import '../ui/builder.dart._';
import '../ui/html.dart';
import '../ui/link.dart';
import '../ui/loader.dart';
import '../user/user_screen.dart';
import 'comment.dart';
import 'comment_placeholder.dart';
import 'format_time.dart';
import 'story_screen.dart';

// const commentMaxDepth = 5;

class CommentLoader extends StatelessWidget {
  CommentLoader(
      {Key? key,
      required this.id,
      this.showNested = true,
      this.depth = 0,
      this.activeUserLink = true,
      this.collapsable = true})
      : super(key: key);

  final int id;
  final int depth;
  final bool showNested;
  final bool activeUserLink;
  final bool collapsable;

  @override
  Widget build(BuildContext context) {
    // return CommentPlaceholder();
    // final notifier = context.watch<HackerNewsNotifier>();

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
  CommentLoaderV2({
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
      load: () => context.read<ItemNotifier>().loadItem(id),
      builder: builder,
    );

    // return FutureBuilder(
    //   future: context.read<ItemNotifier>().loadItem(id),
    //   builder: (BuildContext context, _ ) => builder(context),
    // );

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   context.read<ItemNotifier>().loadItem(id);
    // });
    // return builder(context);
  }

  Widget builder(BuildContext context) {
    // return CommentPlaceholder();
    // final notifier = context.watch<HackerNewsNotifier>();
    print('rebuild: $id');
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
}
