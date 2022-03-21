import 'package:flutter_hacker_news_prototype/src/hacker_news_api_v2.dart';
import 'package:http/http.dart';

Future<void> main() async {
  final client = Client();
  final api  = HackerNewsApiImpl(client);
  final limit = 1;
  final items = await api.topstories(limit);
  print(items);
}
