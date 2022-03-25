import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import '../hacker_news_api.dart';
import '../hacker_news_notifier.dart';
import '../item.dart';
import '../style/style.dart';
import '../user.dart';
import 'comment.dart';
import 'story_tile.dart';
import 'load_indicator.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ItemScreen'),
      ),
      body: Padding(padding: pagePadding, child: ItemWidget(id: id)),
    );
  }
}

class ItemWidget extends StatelessWidget {
  ItemWidget({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<HackerNewsNotifier>();

    return FutureBuilder(
      future: notifier.item(id),
      builder: (BuildContext _, AsyncSnapshot<Item> snap) {
        final error = snap.error;
        if (error != null) {
          onError(context, error);
        }

        final data = snap.data;
        if (data != null) {
          return onData(context, data);
        }

        return onLoading(context);
      },
    );

    // final notifier = context.watch<HackerNewsItemNotifier>();

    // // final error = watchOnly((HackerNewsNotifier v) => v.error);
    // // final data = watchOnly((HackerNewsNotifier v) => v.beststories);

    // final error = notifier.error;
    // if (error != null) {
    //   onError(context, error);
    // }

    // final data = notifier.item;
    // if (data != null) {
    //   return onData(context, data);
    // }

    // return onLoading(context);
  }

  void onError(BuildContext context, Object? error) {
    // navigationService.showSnackBarPostFrame(
    //   error.tr(appLocalizations(context)),
    // );
    // TODO
  }

  Widget onLoading(BuildContext context) {
    return ListView(
      children: [
        // TODO: fix: item load twice
        StoryTilePlaceholder(showLeading: false),
        SizedBox(height: 20),
        // for (final id in data.kids ?? []) CommentLoader(id: id),
        for (int i = 0; i < 20; i++) CommentPlaceholder(depth: 0)
      ],
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
        // TextField(
        //   maxLines: 8,
        //   decoration: InputDecoration(
        //     border: OutlineInputBorder(),
        //     hintText: 'Enter a search term',
        //   ),
        // ),
        // SizedBox(height: 10),
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       minimumSize: Size(50, 40), //////// HERE
        //     ),
        //     onPressed: () => {},
        //     child: Text('add comment'),
        //   ),
        // ),

        // Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // children: [

        for (final id in data.kids ?? []) CommentLoader(id: id),
        // Comment(),
        // Comment(),
        // Comment(),
        // Comment(),
        // Comment(),
        // Comment(),
        // Comment(),
        // Comment(),
        // Comment(),
        // Comment(),
        // Comment(),
        // Comment(),
        // ]),
      ],
    );
  }
}
