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
import '../ui/swipe_to_refresh.dart';
// import 'user_activity_controller.dart';


class UserActivityLoader extends StatelessWidget {
  UserActivityLoader({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read<ItemNotifier>().loadItem(id);
    });
    return builder(context);
  }

  Widget builder(BuildContext context) {
    final activityR =
        context.select<ItemNotifier, ItemResult>((v) => v.item(id));

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
      return Comment(
          item: item,
          showNested: false,
          activeUserLink: false,
          collapsable: false,
          showParentLink: true);
    } else if (item.type == 'story') {
      return StoryTile(item: item, showLeading: false, activeUserLink: false);
    } else {
      print(item.toJson);
      return Container();
    }
  }
}
