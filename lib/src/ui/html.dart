import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HtmlText extends StatelessWidget {
  HtmlText({Key? key, required this.html}) : super(key: key);

  final String html;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(html);

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
    //   },
    //   // shrinkWrap: true,
    // );
  }
}
