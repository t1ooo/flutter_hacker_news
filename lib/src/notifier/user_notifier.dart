import 'package:flutter/foundation.dart';

import 'change_notifier.dart';
import '../hacker_news_api/hacker_news_api.dart';
import '../logging/logging.dart';
import 'result.dart';
import '../hacker_news_api/user.dart';

typedef UserResult = Result<User, Object>;

class UserNotifier extends ChangeNotifier with TryNotifyListeners {
  UserNotifier(this.api);

  final HackerNewsApi api;
  UserResult? _user;
  static final _log = Logger('UserNotifier');

  UserResult get user => _user ?? UserResult.empty();

  Future<void> loadUser(String name) async {
    if (_user == null) {
      await _loadUser(name, true);
    }
  }

  Future<void> reloadUser(String name) async {
    await _loadUser(name, false);
  }

  Future<void> _loadUser(String name, bool cached) async {
    // _log.info('load: $name');
    try {
      final item = await api.user(name, cached);
      _user = UserResult.value(item);
    } on Exception catch (e, st) {
      _log.error(e, st);
      _user = UserResult.error(e);
    }
    tryNotifyListeners();
  }
}
