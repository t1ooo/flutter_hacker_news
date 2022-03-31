import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/user.dart';

import '../notifier/user_notifier.dart';
import '../widget/result_builder.dart';
import 'user_placeholder.dart';
import 'user_widget.dart';

class UserLoader extends StatelessWidget {
  const UserLoader({Key? key, required this.name}) : super(key: key);

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
    return UserPlaceholder();
  }

  Widget onData(BuildContext context, User user) {
    return UserWidget(user: user);
  }
}
