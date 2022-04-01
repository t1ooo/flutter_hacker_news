import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/user.dart';
import '../notifier/item_notifier.dart';
import '../notifier/user_notifier.dart';
import '../widget/result_builder.dart';
import '../widget/swipe_to_refresh.dart';
import 'user_activities.dart';
import 'user_activity/user_activity_placeholder.dart';

class UserActivitiesLoader extends StatelessWidget {
  const UserActivitiesLoader({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return ResultBuilder(
      result: (context) {
        context.read<UserNotifier>().loadUser(name);
        return context.select<UserNotifier, UserResult>((v) => v.user);
      },
      onError: onError,
      onData: onData,
      onLoading: onLoading,
    );
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return ListView(
      children: [for (int i = 0; i < 20; i++) UserActivityPlaceholder()],
    );
  }

  Widget onData(BuildContext context, User user) {
    final submitted = user.submitted ?? [];

    return SwipeToRefresh(
      onRefresh: () async {
        await context.read<UserNotifier>().reloadUser(name);
        await context.read<ItemNotifier>().reloadItems();
      },
      child: UserActivities(submitted: submitted),
    );
  }
}
