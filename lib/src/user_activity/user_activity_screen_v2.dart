// TODO: load user

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/item.dart';
import '../notifier/item_notifier.dart';
import '../story/comment.dart';
import '../story/story_tile.dart';
import '../style/style.dart';
// import 'user_activity_controller.dart';

class UserActivityScreen extends StatelessWidget {
  UserActivityScreen({Key? key, required this.submitted}) : super(key: key);

  List<int> submitted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UserActivityScreen'),
      ),
      body: Padding(
        padding: pagePadding,
        // child: UserActivityList(submitted: submitted),
        child: ChangeNotifierProvider(
          create: (BuildContext context) =>
              ItemNotifier(context.read<HackerNewsApi>()),
          child: UserActivityList(submitted: submitted),
        ),
      ),
    );
  }
}

class UserActivityList extends StatelessWidget {
  UserActivityList({Key? key, required this.submitted}) : super(key: key);

  List<int> submitted;

  @override
  Widget build(BuildContext context) {
    // final notifier = context.watch<HackerNewsNotifier>();

    return onData(context, submitted);

    // return FutureBuilder(
    //   future: Future.delayed(Duration(seconds: 1), () => submitted),
    //   builder: (BuildContext _, AsyncSnapshot<List<int>> snap) {
    //     // final error = snap.error;
    //     // if (error != null) {
    //     //   onError(context, error);
    //     // }

    //     final data = snap.data;
    //     if (data != null) {
    //       return onData(context, data);
    //     }

    //     return onLoading(context);
    //   },
    // );

    // return ListView(
    //   children: [
    //     for (final id in submitted.take(10)) // TODO: pagination ?
    //       // Comment(id: id),
    //       FutureBuilder(
    //         future: notifier.item(id),
    //         builder: (BuildContext _, AsyncSnapshot<Item> snap) {
    //           final error = snap.error;
    //           if (error != null) {
    //             return onError(context, error, snap.stackTrace);
    //           }

    //           final data = snap.data;
    //           if (data != null) {
    //             return onData(context, data);
    //           }

    //           return onLoading(context);
    //         },
    //       ),
    //   ],
    // );
  }

  void onError(BuildContext context, Object? error, StackTrace? st) {
    print(error);
  }

  Widget onLoading(BuildContext context) {
    // return LoadIndicator();
    return ListView(
      children: [for (int i = 0; i < 20; i++) CommentPlaceholder(depth: 0)],
    );
  }

  Widget onData(BuildContext context, List<int> data) {
    // return ListView(
    //   // cacheExtent: 1.5,
    //   children: [
    //     // for (final id in data)  StoryTile(id: id, rank: rank)
    //     for (int id in data)
    //       Padding(
    //         padding: const EdgeInsets.only(bottom: 10),
    //         child: UserActivityLoader(id: id),
    //       )
    //   ],
    // );

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, int i) {
        final id = data[i];
        context.read<ItemNotifier>().loadItem(id);
        return UserActivityLoader(id: id);
      },
    );
  }
}

class UserActivityLoader extends StatelessWidget {
  UserActivityLoader({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final activityR = context
        .select<ItemNotifier, ItemResult>((v) => v.item(id));

    final error = activityR.error;
    if (error != null) {
      return onError(context, error);
    }

    final value = activityR.value;
    if (value != null) {
      return onData(context, value);
    }

    return onLoading(context);
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return CommentPlaceholder(depth: 0);
  }

  Widget onData(BuildContext context, Item item) {
    if (item.type == 'comment') {
      return Comment(item: item, showNested: false, activeUserLink: false);
    } else if (item.type == 'story') {
      return StoryTile(item: item, showLeading: false, activeUserLink: false);
    } else {
      print(item.toJson);
      return Container();
    }
  }
}
