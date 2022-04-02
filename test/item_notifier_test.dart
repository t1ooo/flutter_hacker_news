import 'package:flutter_hacker_news_prototype/src/notifier/comment_notifier.dart';
import 'package:flutter_hacker_news_prototype/src/notifier/item_notifier.dart';
import 'package:test/test.dart';

import 'fake_hacker_news_api.dart';

Future<void> main() async {
  group('ItemNotifier', () {
    const id = 0;
    ItemNotifier create() => ItemNotifier(FakeHackerNewsApi());

    // test('comment should be visible by default', () async {
    //   final commentNotifier = create();

    //   expect(commentNotifier.isVisible(id), true);
    // });

    // test('comment should be not visible after toggle', () async {
    //   final commentNotifier = create();

    //   commentNotifier.toggleVisibility(id);
    //   expect(commentNotifier.isVisible(id), false);
    // });

    // test('comment should be toggle correct', () async {
    //   final commentNotifier = create();

    //   bool isVisible = commentNotifier.isVisible(id);

    //   commentNotifier.toggleVisibility(id);
    //   expect(commentNotifier.isVisible(id), !isVisible);

    //   commentNotifier.toggleVisibility(id);
    //   expect(commentNotifier.isVisible(id), isVisible);
    // });
  });
}
