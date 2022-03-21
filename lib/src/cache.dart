import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'logging/logging.dart';

abstract class Cache {
  Future<String?> get(String key);
  Future<void> put(String key, String value, Duration maxAge);
}

class CacheImpl implements Cache {
  static final _log = Logger('CacheImpl');

  @override
  Future<String?> get(String key) async {
    final fileInfo = await DefaultCacheManager().getFileFromCache(key);
    if (fileInfo == null) {
      _log.info('cache miss: $key');
      return null;
    }
    return fileInfo.file.readAsString();
  }

  @override
  Future<void> put(String key, String value, Duration maxAge) async {
    await DefaultCacheManager()
        .putFile(key, utf8.encoder.convert(value), maxAge: maxAge);
  }
}

class NoCache implements Cache {
  @override
  Future<String?> get(String key) async {
    return null;
  }

  @override
  Future<void> put(String key, String value, Duration maxAge) async {
    return;
  }
}
