import 'package:html/parser.dart';
import 'package:html/dom_parsing.dart';
import 'package:html/dom.dart';

String htmlToText(String html) {
  final prepHtml = html.replaceAll('<p>', '\n\n').replaceAll('<pre>', '\n');
  final document = parse(prepHtml);
  _HtmlVisitor().visit(document);
  return document.body?.text ?? '';
}

class _HtmlVisitor extends TreeVisitor {
  void visitElement(Element node) {
    switch (node.localName) {
      case 'a':
        _repairFullUrl(node);
        break;
    }
    visitNodeFallback(node);
  }

  void _repairFullUrl(Element node) {
    final href = node.attributes['href'] ?? '';
    if (href != '') {
      node.text = href;
    }
  }
}
