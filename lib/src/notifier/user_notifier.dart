import 'package:flutter/foundation.dart';

import 'change_notifier.dart';
import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/item.dart';
import '../logging/logging.dart';
import 'result.dart';
import '../hacker_news_api/user.dart';

typedef UserResult = Result<User, Object>;

class UserNotifier extends ChangeNotifier with TryNotifyListeners {
  UserNotifier(this.api);

  final HackerNewsApi api;
  static final _log = Logger('UserNotifier');
  final int delay = 1;

  UserResult _user = UserResult.empty();

  UserResult get user => _user;

  Future<void> loadUser(String name) async {
    await _loadUser(name, true);
  }

  Future<void> reloadUser(String name) async {
    await _loadUser(name, false);
  }

  // TODO: extract to mixin or function
  Future<void> _loadUser(String name, bool cached) async {
    // print('load: $id');
    _user = await Future.delayed(Duration(seconds: delay), () async {
      try {
        final item = await api.user(name, cached);
        return UserResult.value(item);
      } on Exception catch (e, st) {
        _log.error(e, st);
        return UserResult.error(e);
      }
    });
    tryNotifyListeners();
  }
}
