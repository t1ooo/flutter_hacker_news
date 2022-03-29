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
import '../hacker_news_api/user.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/item_notifier.dart';
import '../notifier/user_notifier.dart';
import '../story/comment.dart';
import '../story/comment_placeholder.dart';
import '../story/story_tile.dart';
import '../style/style.dart';
import '../ui/loader.dart';
import '../ui/swipe_to_refresh.dart';
import 'user_activity_loader.dart';
// import 'user_activity_controller.dart';


// TODO: split to loader and content
class UserActivitiesLoader extends StatelessWidget {
  UserActivitiesLoader({Key? key, required this.name}) : super(key: key);

  String name;

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   context.read<UserNotifier>().loadUser(name);
    // });
    // return builder(context);
    return Loader(
      load: () => context.read<UserNotifier>().loadUser(name),
      builder: builder,
    );
  }

  @override
  Widget builder(BuildContext context) {
    final userR = context.select<UserNotifier, UserResult>((v) => v.user);

    final error = userR.error;
    if (error != null) {
      return onError(context, error);
    }

    final value = userR.value;
    if (value != null) {
      return onData(context, value);
    }

    return onLoading(context);

    // final notifier = context.watch<HackerNewsNotifier>();

    // return onData(context, submitted);

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

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    // return LoadIndicator();
    return ListView(
      children: [for (int i = 0; i < 20; i++) CommentPlaceholder(depth: 0)],
    );
  }

  Widget onData(BuildContext context, User user) {
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

    final submitted = user.submitted ?? [];

    return SwipeToRefresh(
      onRefresh: () async {
        context.read<UserNotifier>().reloadUser(name);
        context.read<ItemNotifier>().reloadItems();
      },
      child: UserActivities(submitted:submitted),
    );
  }
}

class UserActivities extends StatelessWidget {
  UserActivities({Key? key, required this.submitted}) : super(key: key);

  final List<int> submitted;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: submitted.length,
        itemBuilder: (_, int i) {
          final id = submitted[i];
          // context.read<ItemNotifier>().loadItem(id);
          return UserActivityLoader(id: id);
        },
      );
  }
}
