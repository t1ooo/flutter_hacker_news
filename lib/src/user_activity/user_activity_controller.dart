import 'package:flutter/foundation.dart';

import '../hacker_news_api.dart';
import '../item.dart';
import '../logging/logging.dart';
import '../result.dart';
import '../user.dart';

// typedef ActivityIdsResult = Result<List<int>, Object>;
typedef ItemResult = Result<Item, Object>;

// class UserActivityController extends ChangeNotifier {
//   UserActivityController(this.api);

//   final HackerNewsApi api;
//   static final _log = Logger('UserActivityController');
//   final int delay = 1;

//   UserResult _user = UserResult.empty();

//   UserResult get user => _user;

//   Future<void> loadUser(String name) async {
//     _user = await _loadUser(name);
//     notifyListeners();
//   }

//   Future<ItemResult> _loadItem(int id) async {
//     // print('load: $id');
//     return await Future.delayed(Duration(seconds: delay), () async {
//       try {
//         final item = await api.item(id);
//         return ItemResult.value(item);
//       } on Exception catch (e, st) {
//         _log.error(e, st);
//         return ItemResult.error(e);
//       }
//     });
//   }
// }

class UserActivityController extends ChangeNotifier {
  UserActivityController(this.api);

  final HackerNewsApi api;
  static final _log = Logger('UserActivityController');
  final int delay = 1;

  final Map<int, ItemResult> _activities = {};

  ItemResult activity(int id) => _activities[id] ?? ItemResult.empty();

  Future<void> loadActivity(int id) async {
    _activities[id] = await _loadItem(id);
    notifyListeners();
  }

  Future<ItemResult> _loadItem(int id) async {
    // print('load: $id');
    return await Future.delayed(Duration(seconds: delay), () async {
      try {
        final item = await api.item(id);
        return ItemResult.value(item);
      } on Exception catch (e, st) {
        _log.error(e, st);
        return ItemResult.error(e);
      }
    });
  }
}
