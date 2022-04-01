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

class FileCache implements Cache {
  FileCache(int size, [this.clock = const Clock()]) {
    // _cacheManager = DefaultCacheManager();
    const key = 'flutter_cache_manager_cache';
    _cacheManager = CacheManager(
      Config(
        key,
        stalePeriod: Duration(days: 7),
        maxNrOfCacheObjects: size,
      ),
    );
  }

  final Clock clock;
  late final CacheManager _cacheManager;
  static final _log = Logger('CacheImpl');

  @override
  Future<String?> get(String key) async {
    final fileInfo = await _cacheManager.getFileFromCache(key);

    if (fileInfo == null) {
      _log.info('miss: $key');
      return null;
    }

    if (fileInfo.validTill < clock.now()) {
      _log.info('expired: $key');
      await _cacheManager.removeFile(key);
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
  const _CacheItem(
    this.value,
    this.expired,
  );

  final String value;
  final DateTime expired;

  // ignore: sort_constructors_first
  factory _CacheItem.fromJson(Map<String, dynamic> json) => _CacheItem(
        json['value'] as String,
        DateTime.parse(json['expired'] as String),
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'expired': expired.toIso8601String(),
      };
}

class InMemoryCache implements Cache {
  InMemoryCache([this.clock = const Clock()]);

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

    if (item.expired < clock.now()) {
      _log.info('expired: $key');
      _data.remove(key);
      return null;
    }

    return item.value;
  }

  @override
  Future<void> put(String key, String value, Duration maxAge) async {
    final expired = clock.now().add(maxAge);
    _data[key] = _CacheItem(value, expired);
  }
}

class InMemoryLruCache implements Cache {
  InMemoryLruCache(int size, [this.clock = const Clock()]) {
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

    if (item.expired < clock.now()) {
      _log.info('expired: $key');
      _data.remove(key);
      return null;
    }

    return item.value;
  }

  @override
  Future<void> put(String key, String value, Duration maxAge) async {
    final expired = clock.now().add(maxAge);
    _data[key] = _CacheItem(value, expired);
  }
}

class PersistenceLruCache implements Cache {
  PersistenceLruCache(
    int size,
    this.file, {
    this.clock = const Clock(),
    this.saveDelay = const Duration(seconds: 60),
  }) {
    if (saveDelay < Duration.zero) {
      throw Exception('saveDelay < 0');
    }

    _data = LruMap(maximumSize: size);
    _lastUpdate = _lastSave = DateTime(2000);

    _savePeriodic();
  }

  final Clock clock;
  final File file;
  late final Duration saveDelay;
  late final LruMap<String, _CacheItem> _data;
  late DateTime _lastSave;
  late DateTime _lastUpdate;
  static final _log = Logger('PersistenceLruCache');

  @override
  Future<String?> get(String key) async {
    final item = _data[key];

    if (item == null) {
      _log.info('miss: $key');
      return null;
    }

    if (item.expired < clock.now()) {
      _log.info('expired: $key');
      _data.remove(key);
      return null;
    }

    return item.value;
  }

  @override
  Future<void> put(String key, String value, Duration maxAge) async {
    final expired = clock.now().add(maxAge);
    _data[key] = _CacheItem(value, expired);
  }

  Future<void> load() async {
    _log.info('load');
    final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    for (final e in data.entries) {
      final k = e.key;
      final v = _CacheItem.fromJson(e.value as Map<String, dynamic>);
      _data[k] = v;
    }
  }

  Future<void> _savePeriodic() async {
    while (true) {
      if (_lastSave < _lastUpdate) {
        await _save();
      }
      await Future.delayed(saveDelay);
    }
  }

  Future<void> _save() async {
    _log.info('save');
    _lastSave = clock.now();
    final json = jsonEncode(_data);
    await file.writeAsString(json);
  }
}

class EternalFileCache implements Cache {
  EternalFileCache(this.file, [this.clock = const Clock()]) {
    _savePeriodic();
  }

  final File file;
  final Clock clock;
  final Map<String, String> _data = {};

  static final _initDateTime = DateTime(1970);
  DateTime _lastUpdate = _initDateTime;
  DateTime _lastSave = _initDateTime;

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
    _lastUpdate = clock.now();
  }

  Future<void> load() async {
    _log.info('load');
    // ignore: omit_local_variable_types
    final Map<String, String> data = Map.castFrom(
      jsonDecode(await file.readAsString()) as Map<dynamic, dynamic>,
    );
    _data.addAll(data);
  }

  Future<void> _savePeriodic() async {
    while (true) {
      if (_lastSave < _lastUpdate) {
        await _save();
      }
      await Future.delayed(Duration(seconds: 60));
    }
  }

  Future<void> _save() async {
    _log.info('save');
    _lastSave = clock.now();
    final json = jsonEncode(_data);
    await file.writeAsString(json);
  }
}

extension T on DateTime {
  bool operator <(DateTime other) => isBefore(other);
  bool operator >(DateTime other) => isAfter(other);
}
