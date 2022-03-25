import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';

import '../hacker_news_api.dart';
import '../hacker_news_notifier.dart';
import '../item.dart';
import '../style/style.dart';
import '../user.dart';
import 'load_indicator.dart';
import 'story_tile.dart';

class ItemList extends StatelessWidget {
  ItemList({Key? key}) : super(key: key);

  // final hnNotifier = locator<HackerNewsNotifier>()..loadBeststories();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<HackerNewsNotifier>();
    final limit = 1000;
    final offset = 0;

    return FutureBuilder(
      future: notifier.beststories(limit, offset),
      builder: (BuildContext _, AsyncSnapshot<List<int>> snap) {
        final error = snap.error;
        if (error != null) {
          onError(context, error);
        }

        final data = snap.data;
        if (data != null) {
          return onData(context, data, offset + 1);
        }

        return onLoading(context);
      },
    );

    // final hnNotifier = context.watch<HackerNewsNotifier>();
    // // final hnNotifier = locator.get<HackerNewsNotifier>();
    // // final hnNotifier = watch<ValueListenable<HackerNewsNotifier>, HackerNewsNotifier>();

    // // final error = watchOnly((HackerNewsNotifier v) => v.error);
    // // final data = watchOnly((HackerNewsNotifier v) => v.beststories);

    // print('rebuild');

    // final error = hnNotifier.error;
    // if (error != null) {
    //   onError(context, error);
    // }

    // final data = hnNotifier.beststories;
    // if (data != null) {
    //   return onData(context, data);
    // }

    // return onLoading(context);

    // return ListView(
    //   children: [
    //     StoryTile(),
    //     StoryTile(),
    //     StoryTile(),
    //     StoryTile(),
    //     StoryTile(),
    //   ],
    // );
  }

  void onError(BuildContext context, Object? error) {
    print(error);
    // navigationService.showSnackBarPostFrame(
    //   error.tr(appLocalizations(context)),
    // );
    // TODO
  }

  Widget onLoading(BuildContext context) {
    // return LoadIndicator();
    return ListView(
      children: [
        for (int i = 0; i < 20; i++) StoryTilePlaceholder(showLeading: true)
      ],
    );
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, List<int> data, int rank) {
    // return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
    //   Expanded(
    //     child: Shimmer.fromColors(
    //       baseColor: Colors.grey[300]!,
    //       highlightColor: Colors.grey[100]!,
    //       enabled: true,
    //       child: ListView.builder(
    //         itemBuilder: (_, __) => Padding(
    //           padding: const EdgeInsets.only(bottom: 8.0),
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               Container(
    //                 width: 48.0,
    //                 height: 48.0,
    //                 color: Colors.white,
    //               ),
    //               const Padding(
    //                 padding: EdgeInsets.symmetric(horizontal: 8.0),
    //               ),
    //               Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: <Widget>[
    //                     Container(
    //                       width: double.infinity,
    //                       height: 8.0,
    //                       color: Colors.white,
    //                     ),
    //                     const Padding(
    //                       padding: EdgeInsets.symmetric(vertical: 2.0),
    //                     ),
    //                     Container(
    //                       width: double.infinity,
    //                       height: 8.0,
    //                       color: Colors.white,
    //                     ),
    //                     const Padding(
    //                       padding: EdgeInsets.symmetric(vertical: 2.0),
    //                     ),
    //                     Container(
    //                       width: 40.0,
    //                       height: 8.0,
    //                       color: Colors.white,
    //                     ),
    //                   ],
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //         itemCount: 6,
    //       ),
    //     ),
    //   ),
    // ]);

    return ListView(
      children: [
        // for (final id in data)  StoryTile(id: id, rank: rank)
        for (int i = 0; i < data.length; i++)
          StoryTileLoader(id: data[i], rank: rank + i)

        // StoryTile(),
        // StoryTile(),
        // StoryTile(),
        // StoryTile(),
      ],
    );
  }
}
