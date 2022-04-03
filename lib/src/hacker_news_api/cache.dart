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
  void dispose();
}

class FileCache implements Cache {
  FileCache(int size, [this.clock = const Clock()]) {
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

  @override
  void dispose() {}
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

  @override
  void dispose() {}
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

  @override
  void dispose() {}
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

  @override
  void dispose() {}
}

class PersistenceInMemoryLruCache implements Cache {
  PersistenceInMemoryLruCache(
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
  static final _log = Logger('PersistenceInMemoryLruCache');

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
    _lastUpdate = clock.now();
  }

  Future<void> load() async {
    _log.info('load');
    final data = _readJsonFileSync(file);
    for (final e in data.entries) {
      final k = e.key;
      final v = _CacheItem.fromJson(e.value as Map<String, dynamic>);
      _data[k] = v;
    }
    _log.info('load done: ${_data.length}');
  }

  bool _saving = false;
  Timer? _timer;

  Future<void> _savePeriodic() async {
    _timer?.cancel();
    _timer = Timer.periodic(saveDelay, (_) {
      if (!_saving && _lastSave < _lastUpdate) {
        _saving = true;
        _save();
        _saving = false;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
  }

  Future<void> _save() async {
    _log.info('save');
    _lastSave = clock.now();
    final json = jsonEncode(_data);
    await file.writeAsString(json);
  }
}

class EternalFileCache implements Cache {
  EternalFileCache(
    this.file, [
    this.clock = const Clock(),
    this.saveDelay = const Duration(seconds: 60),
  ]) {
    _savePeriodic();
  }

  final File file;
  final Clock clock;
  final Map<String, String> _data = {};

  static final _initDateTime = DateTime(1970);
  DateTime _lastUpdate = _initDateTime;
  DateTime _lastSave = _initDateTime;
  final Duration saveDelay;

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

    final data = _readJsonFileSync(file);
    for (final e in data.entries) {
      final k = e.key;
      final v = e.value as String;
      _data[k] = v;
    }

    _log.info('load done: ${_data.length}');
  }

  bool _saving = false;
  Timer? _timer;

  Future<void> _savePeriodic() async {
    _timer?.cancel();
    _timer = Timer.periodic(saveDelay, (_) {
      if (!_saving && _lastSave < _lastUpdate) {
        _saving = true;
        _save();
        _saving = false;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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

Map<String, dynamic> _readJsonFileSync(File file) {
  final data = file.readAsStringSync();
  if (data == '') {
    return <String, dynamic>{};
  }
  return jsonDecode(data) as Map<String, dynamic>;
}
