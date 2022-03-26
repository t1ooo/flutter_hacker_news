import 'package:flutter/foundation.dart';

import '../hacker_news_api.dart';
import '../item.dart';
import '../logging/logging.dart';
import '../result.dart';
import '../user.dart';

typedef StoryIdsResult = Result<List<int>, Object>;
typedef UserResult = Result<User, Object>;

class UserInfoController extends ChangeNotifier {
  UserInfoController(this.api);

  final HackerNewsApi api;
  static final _log = Logger('UserInfoController');
  final int delay = 1;

  UserResult _userInfo = UserResult.empty();

  UserResult get userInfo => _userInfo;

  Future<void> loadUserInfo(String name) async {
    _userInfo = await _loadUser(name);
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
