import 'package:flutter/material.dart';

import '../util/html.dart';

class HtmlText extends StatelessWidget {
  const HtmlText({Key? key, required this.html}) : super(key: key);

  final String html;

  @override
  Widget build(BuildContext context) {
    // NOTE: flutter_html and flutter_widget_from_html packages throw a render exception when trying to build a comment from HTML
    final text = htmlToText(html);
    return SelectableText(text);
  }
}
