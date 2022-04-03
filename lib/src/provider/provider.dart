import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/cache.dart';
import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/http_client.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/item_notifier.dart';
import '../notifier/story_notifier.dart';
import '../notifier/user_notifier.dart';

const _cacheSize = 1000;
const _cacheBasename = 'flutter_hacker_news_cache.json';

Future<File> _cacheFile() async {
  final tmpPath = (await getTemporaryDirectory()).path;
  final file = File('$tmpPath/$_cacheBasename');
  return file;
}

Future<Cache> createCache() async {
  final file = await _cacheFile();

  if (kIsWeb) {
    return InMemoryLruCache(_cacheSize);
  } else if (Platform.isAndroid) {
    final fileCache = PersistenceInMemoryLruCache(_cacheSize, file);
    await fileCache.load();
    return fileCache;
  } else {
    // TODO: replace to PersistenceInMemoryLruCache
    final fileCache = EternalFileCache(file);
    await fileCache.load();
    return fileCache;
  }
}

Future<Provider<HackerNewsApi>> hackerNewsApiProvider() async {
  final httpClient = HttpClientImpl(Client(), await createCache(), Throttle());
  final hackerNewsApi = HackerNewsApiImpl(httpClient);

  return Provider.value(value: hackerNewsApi);
}

ChangeNotifierProvider<StoryNotifier> storyProvider() {
  return ChangeNotifierProvider(
    create: (BuildContext context) => StoryNotifier(
      context.read<HackerNewsApi>(),
    ),
  );
}

ChangeNotifierProvider<UserNotifier> userProvider() {
  return ChangeNotifierProvider(
    create: (BuildContext context) => UserNotifier(
      context.read<HackerNewsApi>(),
    ),
  );
}

ChangeNotifierProvider<ItemNotifier> itemProvider() {
  return ChangeNotifierProvider(
    create: (BuildContext context) => ItemNotifier(
      context.read<HackerNewsApi>(),
    ),
  );
}

ChangeNotifierProvider<CommentNotifier> commentProvider() {
  return ChangeNotifierProvider(
    create: (BuildContext context) => CommentNotifier(),
  );
}
