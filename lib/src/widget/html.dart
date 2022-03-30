import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';

import '../util/html.dart';
// import '../util/html_to_widget.dart._';

final unescape = HtmlUnescape();

class HtmlText extends StatelessWidget {
  const HtmlText({Key? key, required this.html}) : super(key: key);

  final String html;

  @override
  Widget build(BuildContext context) {
    // return htmlToWidget(html);
    // return Text(htmlToText(html));

    // NOTE: flutter_html and flutter_widget_from_html packages throw a render exception when trying to build a comment from HTML
    return SelectableText(htmlToText(html));

    // final text = unescape
    //     .convert(html)
    //     .replaceAll('<p>', '\n\n')
    //     .replaceAll('</p>', '')
    //     .replaceAll('<i>', '')
    //     .replaceAll('</i>', '')
    //     .replaceAll('<pre>', '')
    //     .replaceAll('</pre>', '')
    //     .replaceAll('<code>', '')
    //     .replaceAll('</code>', '')
    //     .replaceAll('</a>', '')
    //     .replaceAllMapped(
    //       RegExp(r'<a[^>]+href="([^"]+)"[^>]+>'),
    //       (match) => '${match.group(1)} ',
    //     );
    // return Text(text);

    // try {
    // return HtmlWidget(
    //   html,
    //   // renderMode: RenderMode.listView,
    //   // buildAsync: true,
    //   // customStylesBuilder: (_) => null,
    //   // customWidgetBuilder: (element) {
    //     // return Text(element.text);
    //   // },
    //   // isSelectable: false,
    //   // onErrorBuilder: (_, __, ___) {
    //   // return Text('fail to display context');
    //   // },
    // );
    // } on Exception catch (e) {
    //   return Text('fail to display context');
    // }

    // TODO: bug:
    //  exception when fast scroll with mouse
    //  bug reproduced on user activity
    // return Html(
    //   data: html,
    //   style: {
    //     "body": Style(
    //       padding: EdgeInsets.zero,
    //       margin: EdgeInsets.zero,
    //     ),
    //     // "html": Style(),
    //     // "a": Style(),
    //     // "pre": Style(),
    //     // "code": Style(),
    //   },
    //   // customRender: {
    //   //   'p': (RenderContext context, Widget child) {
    //   //     context.parser.htmlData;
    //   //     // context.tree.element?.innerHtml
    //   //     // return TextSpan(text: "🐦");
    //   //   },
    //   //   'a': (RenderContext context, Widget child) {
    //   //     return TextSpan(text: "🐦");
    //   //   },
    //   //   'pre': (RenderContext context, Widget child) {
    //   //     return TextSpan(text: "🐦");
    //   //   },
    //   //   'code': (RenderContext context, Widget child) {
    //   //     return TextSpan(text: "🐦");
    //   //   },
    //   // },
    //   tagsList: ['html', 'body', /* 'p', */ 'a', 'pre', 'code'],
    //   // onLinkTap: (url, _, __, ___) => url != null ? launch(url) : null,
    //   // onMathError: (_, __, ___) => Text('fail to display context'),
    //   // shrinkWrap: true,
    // );
  }
}




