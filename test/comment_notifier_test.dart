import 'package:flutter_hacker_news_prototype/src/notifier/comment_notifier.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group('CommentNotifier', () {
    const id = 0;
    final notifyListenerCallback = MockCallbackFunction();
    late CommentNotifier commentNotifier;
    // CommentNotifier create() =>
    // CommentNotifier()..addListener(notifyListenerCallback);

    setUp(() {
      reset(notifyListenerCallback);
      commentNotifier = CommentNotifier()..addListener(notifyListenerCallback);
    });

    test('should fire notifyListeners', () async {
      // final commentNotifier = create();

      verifyNever(() => notifyListenerCallback());

      commentNotifier.toggleVisibility(id);
      verify(() => notifyListenerCallback()).called(1);
    });

    test('comment should be visible by default', () async {
      // final commentNotifier = create();

      expect(commentNotifier.isVisible(id), true);
    });

    test('comment should be not visible after toggle', () async {
      // final commentNotifier = create();

      commentNotifier.toggleVisibility(id);
      expect(commentNotifier.isVisible(id), false);
    });

    test('comment should be toggle correct', () async {
      // final commentNotifier = create();

      final isVisible = commentNotifier.isVisible(id);

      commentNotifier.toggleVisibility(id);
      expect(commentNotifier.isVisible(id), !isVisible);

      commentNotifier.toggleVisibility(id);
      expect(commentNotifier.isVisible(id), isVisible);
    });
  });
}

class MockCallbackFunction extends Mock {
  call();
}
