import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/cache.dart';
import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/http_client.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/item_notifier.dart';
import '../notifier/story_notifier.dart';
import '../notifier/user_notifier.dart';

Future<Provider<HackerNewsApi>> hackerNewsApiProvider() async {
  final cache = EternalFileCache(
    File(
      '/home/graibn/GoogleDrive/dev/project/source/flutter_hacker_news_prototype/data/data.json',
    ),
  );
  await cache.load();
  final httpClient = HttpClientImpl(Client(), cache, Throttle());
  final hackerNewsApi = HackerNewsApiImpl(httpClient);

  return Provider.value(value: hackerNewsApi);
}

ChangeNotifierProvider<StoryNotifier> storyProvider(BuildContext context) {
  return ChangeNotifierProvider(
    create: (BuildContext context) => StoryNotifier(
      context.read<HackerNewsApi>(),
    ),
  );
}

ChangeNotifierProvider<UserNotifier> userProvider(BuildContext context) {
  return ChangeNotifierProvider(
    create: (BuildContext context) => UserNotifier(
      context.read<HackerNewsApi>(),
    ),
  );
}

ChangeNotifierProvider<ItemNotifier> itemProvider(BuildContext context) {
  return ChangeNotifierProvider(
    create: (BuildContext context) => ItemNotifier(
      context.read<HackerNewsApi>(),
    ),
  );
}

ChangeNotifierProvider<CommentNotifier> commentProvider(BuildContext context) {
  return ChangeNotifierProvider(
    create: (BuildContext context) => CommentNotifier(),
  );
}
