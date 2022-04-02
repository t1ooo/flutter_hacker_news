import 'dart:io';

import 'package:flutter_hacker_news_prototype/src/hacker_news_api/cache.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test/test.dart';

// TODO: test cache size

const size = 100;
const key = 'k1';
const value = 'v1';
const maxAge = Duration(seconds: 1);

Future<void> main() async {
  final file = await cacheFile();

  testCache('InMemoryCache', () => InMemoryCache());
  testCache('FileCache', () => FileCache(size));
  testCache('InMemoryLruCache', () => InMemoryLruCache(size));
  testCache(
    'PersistenceInMemoryLruCache',
    () => PersistenceInMemoryLruCache(size, file),
  );

  group('NoCache', () {
    Cache createCache() => NoCache();

    test('value should not be available', () async {
      final cache = createCache();

      await cache.put(key, value, maxAge);
      expect(await cache.get(key), null);
    });
  });

  group('EternalFileCache', () {
    Cache createCache() => EternalFileCache(file);

    test('value should be available after expiration', () async {
      final cache = createCache();

      await cache.put(key, value, maxAge);
      await Future.delayed(maxAge);
      expect(await cache.get(key), value);
    });
  });
}

void testCache(String name, Cache Function() createCache) {
  group(name, () {
    test('value should be available', () async {
      final cache = createCache();

      await cache.put(key, value, maxAge);
      expect(await cache.get(key), value);
    });

    test('value should be available before expiration', () async {
      final cache = createCache();

      await cache.put(key, value, maxAge);
      await Future.delayed(maxAge ~/ 2);
      expect(await cache.get(key), value);
    });

    test('value should not be available after expiration ', () async {
      final cache = createCache();

      await cache.put(key, value, maxAge);
      expect(await cache.get(key), value);

      await Future.delayed(maxAge);
      expect(await cache.get(key), null);
    });
  });
}

Future<File> cacheFile() async {
  final tmpPath = (await getTemporaryDirectory()).path;
  final file = File('$tmpPath/flutter_test_cache.json');
  await file.writeAsString(''); // truncate file
  return file;
}
