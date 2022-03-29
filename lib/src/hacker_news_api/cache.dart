import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:quiver/collection.dart';

import '../clock/clock.dart';
import '../logging/logging.dart';

abstract class Cache {
  Future<String?> get(String key);
  Future<void> put(String key, String value, Duration maxAge);
}

// TODO: use key value storage
class FileCache implements Cache {
  FileCache(int size, this.clock) {
    // _cacheManager = DefaultCacheManager();
    const key = 'flutter_cache_manager_cache';
    _cacheManager = CacheManager(
      Config(
        key,
        stalePeriod: Duration(days: 7),
        maxNrOfCacheObjects: size,
        // repo: JsonCacheInfoRepository(_databaseName: key),
        // fileSystem: IOFileSystem(key),
        // fileService: HttpFileService(),
      ),
    );
  }

  final Clock clock;
  late final CacheManager _cacheManager;
  static final _log = Logger('CacheImpl');

  @override
  Future<String?> get(String key) async {
    final fileInfo = await _cacheManager.getFileFromCache(key);
    // if (fileInfo != null && fileInfo.validTill.isAfter(clock.now())) {
    // if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now())) {
    // return fileInfo.file.readAsString();
    // }

    // _log.info('miss: $key');
    // return null;

    if (fileInfo == null) {
      _log.info('miss: $key');
      return null;
    }

    if (clock.now().isAfter(fileInfo.validTill)) {
      _log.info('expired: $key');
      _cacheManager.removeFile(key);
      return null;
    }

    return fileInfo.file.readAsString();
  }

  @override
  Future<void> put(String key, String value, Duration maxAge) async {
    await _cacheManager.putFile(
      key,
      utf8.encoder.convert(value),
      maxAge: maxAge,
    );
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

class _CacheItem {
  final String value;
  // final Duration maxAge;
  final DateTime expired;

  _CacheItem(
    this.value,
    this.expired,
  );
}

class InMemoryCache implements Cache {
  InMemoryCache(this.clock);

  final Map<String, _CacheItem> _data = {};
  final Clock clock;
  static final _log = Logger('InMemoryCache');

  @override
  Future<String?> get(String key) async {
    final item = _data[key];

    if (item == null) {
      _log.info('miss: $key');
      return null;
    }

    if (clock.now().isAfter(item.expired)) {
      _log.info('expired: $key');
      _data.remove(key);
      return null;
    }

    // _log.info('hit: $key');
    return item.value;
  }

  @override
  Future<void> put(String key, String value, Duration maxAge) async {
    final expired = clock.now().add(maxAge);
    _data[key] = _CacheItem(value, expired);
  }
}

class InMemoryLruCache implements Cache {
  InMemoryLruCache(int size, this.clock) {
    _data = LruMap(maximumSize: size);
  }

  late final LruMap<String, _CacheItem> _data;
  final Clock clock;
  static final _log = Logger('InMemoryLruCache');

  @override
  Future<String?> get(String key) async {
    final item = _data[key];

    if (item == null) {
      _log.info('miss: $key');
      return null;
    }

    if (clock.now().isAfter(item.expired)) {
      _log.info('expired: $key');
      _data.remove(key);
      return null;
    }

    // _log.info('hit: $key');
    return item.value;
  }

  @override
  Future<void> put(String key, String value, Duration maxAge) async {
    final expired = clock.now().add(maxAge);
    _data[key] = _CacheItem(value, expired);
  }
}

class EternalFileCache implements Cache {
  EternalFileCache(this.file) {
    Timer.periodic(Duration(seconds: 60), (_) {
      _save();
    });
  }

  final File file;
  final Map<String, String> _data = {};
  static final _log = Logger('EternalFileCache');

  @override
  Future<String?> get(String key) async {
    final item = _data[key];

    if (item == null) {
      _log.info('miss: $key');
      return null;
    }

    return item;
  }

  @override
  Future<void> put(String key, String value, Duration maxAge) async {
    _data[key] = value;
    // await _save();
  }

  Future<void> load() async {
    _log.info('load');
    // final data = (jsonDecode(await file.readAsString()) as Map<String, String>).map((v) => v as String);
    final  Map<String, String> data = Map.castFrom(jsonDecode(await file.readAsString()));
    _data.addAll(data);
  }

  Future<void> _save() async {
    _log.info('save');
    final json = jsonEncode(_data);
    await file.writeAsString(json);
  }
}
