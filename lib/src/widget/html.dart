import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';

final unescape = HtmlUnescape();

class HtmlText extends StatelessWidget {
  HtmlText({Key? key, required this.html}) : super(key: key);

  final String html;

  @override
  Widget build(BuildContext context) {
    // final text =  unescape.convert(html)
    //     // .replaceAll('&#x27;', "'")
    //     // .replaceAll('&#x2F;', "/")
    //     .replaceAll('<p>', '\n\n')
    //     .replaceAll('</p>', '')
    //     // .replaceAll('&gt;', '>')
    //     .replaceAll('<pre>', '')
    //     .replaceAll('</pre>', '')
    //     .replaceAll('<code>', '')
    //     .replaceAll('</code>', '')
    //     // .replaceAll(RegExp(r'<a[^>]+>'), '')
    //     // .replaceAll('&quot;', '"')
    // ;
    // return Text(text);
    
    // try {
    //   return HtmlWidget(
    //     html,
    //     isSelectable: false,
    //     onErrorBuilder: (_, __, ___) {
    //       return Text('fail to display context');
    //     },
    //   );
    // } on Exception catch (e) {
    //   return Text('fail to display context');
    // }

    // TODO: bug:
    //  exception when fast scroll with mouse
    //  bug reproduced on user activity
    return Html(
      data: html,
      style: {
        "body": Style(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
        ),
      },
      onLinkTap: (url, _, __, ___) => url != null ? launch(url) : null,
      onMathError: (_, __, ___) => Text('fail to display context'),
      // shrinkWrap: true,
    );
  }
}
