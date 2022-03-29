import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/user.dart';
import '../notifier/item_notifier.dart';
import '../notifier/user_notifier.dart';
import '../story/comment/comments_placeholder.dart';
import '../widget/loader.dart';
import '../widget/result_builder.dart';
import '../widget/swipe_to_refresh.dart';
import 'user_activities.dart';

class UserActivitiesLoader extends StatelessWidget {
  const UserActivitiesLoader({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Loader(
      load: (context) => context.read<UserNotifier>().loadUser(name),
      builder: builder,
    );
  }

  // Widget builder(BuildContext context) {
  //   final userR = context.select<UserNotifier, UserResult>((v) => v.user);

  //   final error = userR.error;
  //   if (error != null) {
  //     return onError(context, error);
  //   }

  //   final value = userR.value;
  //   if (value != null) {
  //     return onData(context, value);
  //   }

  //   return onLoading(context);
  // }

  Widget builder(BuildContext context) {
    return ResultBuilder(
      result: (context) =>
          context.select<UserNotifier, UserResult>((v) => v.user),
      onError: onError,
      onData: onData,
      onLoading: onLoading,
    );
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return CommentsPlaceholder();
  }

  Widget onData(BuildContext context, User user) {
    final submitted = user.submitted ?? [];

    return SwipeToRefresh(
      onRefresh: () async {
        context.read<UserNotifier>().reloadUser(name);
        context.read<ItemNotifier>().reloadItems();
      },
      child: UserActivities(submitted: submitted),
    );
  }
}
