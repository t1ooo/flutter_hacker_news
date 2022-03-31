// import 'package:flutter_hacker_news_prototype/logger.dart';
// import 'package:html/dom_parsing.dart';
// import 'package:html/parser.dart';
// import 'package:html/dom.dart';

// Future<void> main() async {
//   configureLogger(true);
//   final html = '''
// <p>paragraph  <a href="https://example.com/path/path2">example.com/path/p...</a> </p>
// ''';

//   final document = parse(html);
//   print(getText(document));
// }


// String getText(Node node) => (DomVisitor()..visit(node)).toString();

// class DomVisitor extends TreeVisitor {
//   final _str = StringBuffer();

//   @override
//   String toString() => _str.toString();

//   @override
//   void visitText(Text node) {
//     _str.write(node.data);
//   }

//   // void visitNodeFallback(Node node) => visitChildren(node);

//   // void visitDocument(Document node) => visitNodeFallback(node);

//   // void visitDocumentType(DocumentType node) => visitNodeFallback(node);

//   // void visitText(Text node) => visitNodeFallback(node);

//   void visitElement(Element node) {
//     // print(node.localName);
//     if (node.localName == 'a') {
//       final href = node.attributes['href'] ?? '';
//       // final parent = node.parent;
//       // if (parent != null) {
//       //   parent.
//       // }
//       node.text = href;
//     }
//     visitNodeFallback(node);
//   }

//   // void visitComment(Comment node) => visitNodeFallback(node);

//   // void visitDocumentFragment(DocumentFragment node) => visitNodeFallback(node);
// }

int counter = 0;

Future<T> trottle<T>(Future<T> Function() fn) async {
  await Future.delayed(Duration(seconds:1)*counter);
  counter++;
  final result = await fn();
  counter--;
  return result;
}

typedef Fn<T> = Future<T> Function();

Fn<T> trottleFn<T>(Future<T> Function() fn) {
  int counter = -1;
  Future<T> f() async {
    counter++;
    await Future.delayed(Duration(seconds:1)*counter);
    final result = await fn();
    counter--;
    return result;
  }
  return f;
}

Fn<T> trottleFnV2<T>(Future<T> Function() fn) {
  int counter = -1;
  DateTime last = DateTime(1970);
  final delay = Duration(seconds:1);
  Future<T> f() async {
    final diff = delay - DateTime.now().difference(last).abs();
    counter++;
    if (counter == 0 && diff > Duration.zero) {
      await Future.delayed(diff);
    } else {
      await Future.delayed(Duration(seconds:1)*counter);
    }
    final result = await fn();
    last = DateTime.now();
    counter--;
    return result;
  }
  return f;
}

Fn<T> trottleFnV3<T>(Future<T> Function() fn) {
  int counter = 0;
  Future<T> f() async {
    counter++;
    await Future.delayed(Duration(seconds:1)*counter);
    final result = await fn();
    counter--;
    return result;
  }
  return f;
}

void main() async {
  final fn = trottleFnV3(() async {
    print(DateTime.now());
  });  
  for(var i=0; i<10; i++) {
    fn();
  }
}
