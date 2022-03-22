import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

import 'src/hacker_news_api.dart';
import 'src/hacker_news_notifier.dart';

final locator = GetIt.instance;

Future<void> initLocator() async {
  final hackerNewsApi = HackerNewsApiImpl(Client());

  final hackerNewsNotifier = HackerNewsNotifier(hackerNewsApi)
    ..loadBeststories(10, 0);
  // final hackerNewsNotifier = HackerNewsNotifier(hackerNewsApi);
  // hackerNewsNotifier.loadBeststories();
  locator.registerSingleton<HackerNewsNotifier>(hackerNewsNotifier);

  locator.registerFactoryParam<HackerNewsItemNotifier, int, void>(
    (id, _) => HackerNewsItemNotifier(hackerNewsApi)..loadItem(id),
  );
}
