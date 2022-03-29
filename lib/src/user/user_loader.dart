import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

// import '../hacker_news_notifier.dart';

import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/user.dart';
import '../story/comment.dart';
import '../style/style.dart';
import '../ui/html.dart';
import '../ui/link.dart';
import '../ui/loader.dart';
import '../user_activity/user_activity_screen_v2.dart';
import '../notifier/user_notifier.dart';
import 'user_placeholder.dart';
import 'user_widget.dart';


class UserLoader extends StatelessWidget {
  // TODO: remove name
  UserLoader({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Loader(
      load: () => context.read<UserNotifier>().loadUser(name),
      builder: builder,
    );

    // return FutureBuilder(
    //   future: context.read<ItemNotifier>().loadItem(id),
    //   builder: (BuildContext context, _ ) => builder(context),
    // );

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   context.read<UserNotifier>().loadUser(name);
    // });
    // return builder(context);
  }

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
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return UserPlaceholder();
    // return Container();
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, User user) {
    return UserWidget(user: user);
  }
}
