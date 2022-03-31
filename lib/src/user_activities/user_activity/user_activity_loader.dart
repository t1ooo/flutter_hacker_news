import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../hacker_news_api/item.dart';
import '../../notifier/item_notifier.dart';
import '../../widget/result_builder.dart';
import 'user_activity.dart';
import 'user_activity_placeholder.dart';

class UserActivityLoader extends StatelessWidget {
  const UserActivityLoader({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return ResultBuilder(
      result: (context) {
        context.read<ItemNotifier>().loadItem(id);
        return context.select<ItemNotifier, ItemResult>((v) => v.item(id));
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
    return UserActivityPlaceholder();
  }

  Widget onData(BuildContext context, Item item) {
    return UserActivity(item: item);
  }
}
