import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../clock/clock.dart';
import '../hacker_news_api/cache.dart';
import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/http_client.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/item_notifier.dart';
import '../notifier/story_notifier.dart';
import '../notifier/user_notifier.dart';

Future<Provider<HackerNewsApi>> hackerNewsApiProvider() async {
  final clock = Clock();
  // final cache = InMemoryCache(clock);
  // final cache = InMemoryLruCache(1000, clock);
  final cache = EternalFileCache(
    File(
        '/home/graibn/GoogleDrive/dev/project/source/flutter_hacker_news_prototype/data/data.json'),
    clock,
  );
  await cache.load();
  final httpClient = HttpClientImpl(Client(), cache);
  final hackerNewsApi = HackerNewsApiImplV2(httpClient);
  // final hackerNewsApi = HackerNewsApiImpl(Client(), cache);

  return Provider.value(value: hackerNewsApi);
}

ChangeNotifierProvider<StoryNotifier> storyProvider(context) {
  return ChangeNotifierProvider(
    create: (BuildContext context) =>
        StoryNotifier(context.read<HackerNewsApi>()),
  );
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
