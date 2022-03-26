import 'package:flutter/foundation.dart';

import '../hacker_news_api.dart';
import '../item.dart';
import '../logging/logging.dart';
import '../result.dart';
import '../user.dart';

typedef StoryIdsResult = Result<List<int>, Object>;
typedef UserResult = Result<User, Object>;

class UserController extends ChangeNotifier {
  UserController(this.api);

  final HackerNewsApi api;
  static final _log = Logger('UserController');
  final int delay = 1;

  UserResult _user = UserResult.empty();

  UserResult get user => _user;

  Future<void> loadUser(String name) async {
    _user = await _loadUser(name);
    notifyListeners();
  }

  // TODO: extract to mixin or function
  Future<UserResult> _loadUser(String name) async {
    // print('load: $id');
    return await Future.delayed(Duration(seconds: delay), () async {
      try {
        final item = await api.user(name);
        return UserResult.value(item);
      } on Exception catch (e, st) {
        _log.error(e, st);
        return UserResult.error(e);
      }
    });
  }
}
