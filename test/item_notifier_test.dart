import 'package:flutter_hacker_news_prototype/src/notifier/item_notifier.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'fake_hacker_news_api.dart';
import 'mock.dart';

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
      verifyNever(() => notifyListenerCallback());

      await itemNotifier.loadItem(id);
      verify(() => notifyListenerCallback()).called(1);
    });

    test('should fire notifyListeners', () async {
      verifyNever(() => notifyListenerCallback());

      await itemNotifier.reloadItem(id);
      verify(() => notifyListenerCallback()).called(1);
    });

    test('should fire notifyListeners', () async {
      await itemNotifier.loadItem(id);
      reset(notifyListenerCallback);

      verifyNever(() => notifyListenerCallback());

      await itemNotifier.reloadItems(awaited: true);
      verify(() => notifyListenerCallback()).called(1);
    });

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
