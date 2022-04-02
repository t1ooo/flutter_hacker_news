import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hacker_news_prototype/src/notifier/item_notifier.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'fake_hacker_news_api.dart';
import 'mock.dart';

void testFireNotifyListeners<T extends ChangeNotifier>(
  String name,
  FutureOr<T> Function() createNotifier,
  Future<void> Function(T, MockListenerFunction) fn, {
  int called = 1,
}) async {
  test('call $name should fire notifyListeners', () async {
    final notifier = await createNotifier();
    final listener = MockListenerFunction();
    notifier.addListener(listener);
    await fn(notifier, listener);
    verify(listener).called(called);
  });
}

// Future<void> testFireNotifyListenersV2<T extends ChangeNotifier>(
//   String name,
//   FutureOr<T> Function() createNotifier,
//   Future<void> Function(T, MockListenerFunction) fn, {
//   int called = 1,
// }) async {
//   final notifier = await createNotifier();
//   final listener = MockListenerFunction();
//   notifier.addListener(listener);
//   await fn(notifier, listener);
//   verify(listener).called(called);
// }

Future<void> testCalled(
  Future<void> Function(MockListenerFunction) fn, [
  int called = 1,
]) async {
  final listener = MockListenerFunction();
  await fn(listener);
  verify(listener).called(called);
}

/* 
testFireNotifyListeners(notifier, () => itemNotifier.loadItem(id))


void testFireNotifyListeners<T extends ChangeNotifier>(T notifier) {
  final listener = MockListenerFunction();
  notifier.addListener(listener);
  await fn(notifier, listener);
}

 */

Future<void> main() async {
  group('ItemNotifier', () {
    const id = 0;
    final notifyListenerCallback = MockListenerFunction();
    late ItemNotifier itemNotifier;

    setUp(() {
      reset(notifyListenerCallback);
      itemNotifier = ItemNotifier(FakeHackerNewsApi())
        ..addListener(notifyListenerCallback);
    });

    test('should fire notifyListeners', () async {
      verifyNever(notifyListenerCallback);
      await itemNotifier.loadItem(id);
      verify(notifyListenerCallback).called(1);
    });
    // testFireNotifyListeners<ItemNotifier>(
    //   'loadItem',
    //   () => ItemNotifier(FakeHackerNewsApi()),
    //   (itemNotifier, _) => itemNotifier.loadItem(id),
    // );
    // test('should fire notifyListeners after loadItem', () async {
    //   await testCalled((listener) async {
    //     itemNotifier.addListener(listener);
    //     await itemNotifier.loadItem(id);
    //   });
    // });

    test('should fire notifyListeners', () async {
      verifyNever(notifyListenerCallback);
      await itemNotifier.reloadItem(id);
      verify(notifyListenerCallback).called(1);
    });
    // testFireNotifyListeners<ItemNotifier>(
    //   'reloadItem',
    //   () => ItemNotifier(FakeHackerNewsApi()),
    //   (itemNotifier, _) => itemNotifier.reloadItem(id),
    // );
    // test('should fire notifyListeners after reloadItem', () async {
    //   await testCalled((listener) async {
    //     itemNotifier.addListener(listener);
    //     await itemNotifier.reloadItem(id);
    //   });
    // });

    test('should fire notifyListeners', () async {
      await itemNotifier.loadItem(id);
      reset(notifyListenerCallback);

      verifyNever(notifyListenerCallback);
      await itemNotifier.reloadItems(awaited: true);
      verify(notifyListenerCallback).called(1);
    });
    // testFireNotifyListeners<ItemNotifier>(
    //   'reloadItems',
    //   () async {
    //     final n = ItemNotifier(FakeHackerNewsApi());
    //     await n.loadItem(id);
    //     return n;
    //   },
    //   (itemNotifier, _) => itemNotifier.reloadItems(awaited: true),
    // );
    // test('should fire notifyListeners after reloadItems', () async {
    //   await testCalled((listener) async {
    //     await itemNotifier.loadItem(id);

    //     itemNotifier.addListener(listener);
    //     await itemNotifier.reloadItems(awaited: true);
    //   });
    // });

    test('item should be not exist by default', () async {
      expect(itemNotifier.item(id), ItemResult.empty());
    });

    test('item should be exist after loadItem', () async {
      await itemNotifier.loadItem(id);
      final itemR = itemNotifier.item(id);
      expect(itemR.error, null);
      expect(itemR.value?.id, id);
    });

    test('should be use cached item between loadItem', () async {
      await itemNotifier.loadItem(id);
      final time1 = itemNotifier.item(id).value!.time;

      // await Future.delayed(Duration(seconds: 1));

      await itemNotifier.loadItem(id);
      final time2 = itemNotifier.item(id).value!.time;

      expect(time1, time2);
    });

    test('should be use new item after reloadItem', () async {
      await itemNotifier.loadItem(id);
      final time1 = itemNotifier.item(id).value!.time;

      // await Future.delayed(Duration(seconds: 1));

      await itemNotifier.reloadItem(id);
      final time2 = itemNotifier.item(id).value!.time;

      expect(time1, isNot(equals(time2)));
    });

    test('should be use new item after reloadItems', () async {
      await itemNotifier.loadItem(id);
      final time1 = itemNotifier.item(id).value!.time;

      // await Future.delayed(Duration(seconds: 1));

      await itemNotifier.reloadItems(awaited: true);
      final time2 = itemNotifier.item(id).value!.time;

      expect(time1, isNot(equals(time2)));
    });

    // test('comment should be not visible after toggle', () async {
    //   commentNotifier.toggleVisibility(id);
    //   expect(commentNotifier.isVisible(id), false);
    // });

    // test('comment should be toggle correct', () async {
    //   final isVisible = commentNotifier.isVisible(id);

    //   commentNotifier.toggleVisibility(id);
    //   expect(commentNotifier.isVisible(id), !isVisible);

    //   commentNotifier.toggleVisibility(id);
    //   expect(commentNotifier.isVisible(id), isVisible);
    // });
  });
}
