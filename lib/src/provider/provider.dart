import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../clock/clock.dart';
import '../hacker_news_api/cache.dart';
import '../hacker_news_api/hacker_news_api.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/item_notifier.dart';
import '../notifier/user_notifier.dart';

Provider<HackerNewsApi> hackerNewsApiProvider() {
  final clock = Clock();
  // final cache = InMemoryCache(clock);
  final cache = InMemoryLruCache(1000, clock);
  final hackerNewsApi = HackerNewsApiImpl(Client(), cache);

  return Provider.value(value: hackerNewsApi);
}

ChangeNotifierProvider<UserNotifier> userProvider(context) {
  return ChangeNotifierProvider(
    create: (BuildContext context) =>
        UserNotifier(context.read<HackerNewsApi>()),
  );
}

ChangeNotifierProvider<ItemNotifier> itemProvider(context) {
  return ChangeNotifierProvider(
    create: (BuildContext context) => ItemNotifier(
      context.read<HackerNewsApi>(),
    ),
  );
}

ChangeNotifierProvider<CommentNotifier> commentProvider(context) {
  return ChangeNotifierProvider(
    create: (BuildContext context) => CommentNotifier(),
  );
}
