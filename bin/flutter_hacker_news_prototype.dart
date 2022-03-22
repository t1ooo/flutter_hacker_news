import 'package:flutter_hacker_news_prototype/logger.dart';
import 'package:flutter_hacker_news_prototype/src/cache.dart';
import 'package:flutter_hacker_news_prototype/src/hacker_news_api_v2.dart';
import 'package:http/http.dart';

Future<void> main() async {
  configureLogger(true);
  final client = Client();
  final cache = CacheImpl();
  final api = HackerNewsApiImpl(client, cache);
  {
    final limit = 5;
    final items = await api.topstories(limit);
    // print('items: ${items.toJson()}');
    // items.forEach((v) {
    //   print(v);
    // });
    items.forEach((v) {
      print(v.toJson());
    });
  }

  {
    final limit = 5;
    final id = 30749134;
    final items = await api.item(id, limit);
    print(items.toJson());
    // print(item);
    // items.forEach((v) {
    // print(v.toJson());
    // });
  }
}
