import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/user.dart';
import '../widget/loader.dart';
import '../notifier/user_notifier.dart';
import 'user_placeholder.dart';
import 'user_widget.dart';

class UserLoader extends StatelessWidget {
  UserLoader({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Loader(
      load: (context) => context.read<UserNotifier>().loadUser(name),
      builder: builder,
    );
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
  }

  Widget onData(BuildContext context, User user) {
    return UserWidget(user: user);
  }
}
