import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news_prototype/src/item_notifier.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import '../hacker_news_api.dart';
import '../item.dart';
import 'story_tile.dart';
import '../style/style.dart';
import 'comment.dart';


class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StoryScreen'),
      ),
      body: Padding(
        padding: pagePadding,
        // child: Story(id: id),
        child: ChangeNotifierProvider(
          create: (BuildContext context) =>
              ItemNotifier(context.read<HackerNewsApi>())..loadItem(id),
          child: Story(id: id),
        ),
      ),
    );
  }
}

class Story extends StatelessWidget {
  Story({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    // final notifier = context.watch<HackerNewsNotifier>();
    final storyR = context.select<ItemNotifier, ItemResult>((v) => v.item(id));

    final error = storyR.error;
    if (error != null) {
      return onError(context, error);
    }

    final value = storyR.value;
    if (value != null) {
      return onData(context, value);
    }

    return onLoading(context);
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(e.toString());
  }

  // Widget onLoading(BuildContext context) {
  //   return ListView(
  //     children: [
  //       // TODO: fix: item load twice
  //       StoryTilePlaceholder(showLeading: false),
  //       SizedBox(height: 20),
  //       // for (final id in data.kids ?? []) CommentLoader(id: id),
  //       for (int i = 0; i < 20; i++) CommentPlaceholder(depth: 0)
  //     ],
  //   );
  // }

  Widget onLoading(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (_, __) {
        return CommentPlaceholder(depth: 0);
      },
    );
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, Item data) {
    return ListView(
      children: [
        // TODO: fix: item load twice
        StoryTileLoader(
            id: data.id,
            rank: 0,
            showLeading: false,
            activeCommentsLink: false),
        SizedBox(height: 20),

        if (data.kids != null)
          ListView.builder(
            shrinkWrap: true,
            itemCount: data.kids!.length,
            itemBuilder: (_, int i) {
              final id = data.kids![i];
              context.read<ItemNotifier>().loadItem(id);
              return CommentLoader(id: id);
            },
          ),
      ],
    );
  }
}
