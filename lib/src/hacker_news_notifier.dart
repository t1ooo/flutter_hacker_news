import 'package:flutter/foundation.dart';

import 'hacker_news_api.dart';
import 'item.dart';
import 'logging/logging.dart';
import 'user.dart';

class HackerNewsNotifier extends ChangeNotifier {
  HackerNewsNotifier(this.api);

  final HackerNewsApi api;
  static final _log = Logger('HackerNewsNotifier');
  // List<int>? _beststories;
  // Object? _error;

  // List<int>? get beststories => _beststories;

  // Object? get error {
  //   final tmp = _error;
  //   _error = null;
  //   return tmp;
  // }

  // Future<void> loadBeststories(int limit, int offset) async {
  //   _beststories = (await api.topstories()).skip(offset).take(limit).toList();
  //   notifyListeners();
  // }

  // TODO: rename beststories -> topstories
  Future<List<int>> beststories(int limit, int offset) async {
    return (await api.topstories()).skip(offset).take(limit).toList();
  }

  Future<Item> item(int id) async {
    // _log.info('load item: $id');
    // return await api.item(id);
    return Future.delayed(Duration(seconds: 1), () => api.item(id));
  }

  Future<User> user(String name) async {
    // _log.info('load user: $name');
    return await api.user(name);
  }

  // Future<Item> item(int id);
  // Future<User> user(String name);
  // Future<int> maxitem();
  // Future<List<int>> topstories();
  // Future<List<int>> newstories();
  // Future<List<int>> askstories();
  // Future<List<int>> showstories();
  // Future<List<int>> jobstories();
  // Future<Updates> updates();
}

// class HackerNewsItemNotifier extends ChangeNotifier {
//   HackerNewsItemNotifier(this.api) {
//     _log.info('new');
//   }

//   final HackerNewsApi api;
//   Item? _item;
//   Object? _error;
//   static final _log = Logger('HackerNewsItemNotifier');

//   Item? get item => _item;

//   @override
//   void dispose() {
//     _log.info('dispose: ${_item?.id}');
//     super.dispose();
//   }

//   Object? get error {
//     final tmp = _error;
//     _error = null;
//     return tmp;
//   }

//   Future<void> loadItem(int id) async {
//     _log.info('load: $id');
//     _item = await api.item(id);
//     notifyListeners();
//   }

//   // Future<Item> item(int id);
//   // Future<User> user(String name);
//   // Future<int> maxitem();
//   // Future<List<int>> topstories();
//   // Future<List<int>> newstories();
//   // Future<List<int>> askstories();
//   // Future<List<int>> showstories();
//   // Future<List<int>> jobstories();
//   // Future<Updates> updates();
// }
