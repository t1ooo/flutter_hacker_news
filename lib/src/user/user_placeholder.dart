import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

// import '../hacker_news_notifier.dart';

import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/user.dart';
import '../story/comment.dart';
import '../style/style.dart';
import '../ui/html.dart';
import '../ui/link.dart';
import '../user_activity/user_activity_screen_v2.dart';
import '../notifier/user_notifier.dart';

class UserPlaceholder extends StatelessWidget {
  UserPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      backgroundColor: Colors.white,
    );

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(flex: 0.15),
          1: FlexColumnWidth(),
        },
        children: [
          TableRow(
            children: [
              Text('user:', style: textStyle), // TODO: move to widget
              Text('_' * 10, style: textStyle),
            ],
          ),
          TableRow(
            children: [
              Text('created:', style: textStyle),
              Text('_' * 10, style: textStyle),
            ],
          ),
          TableRow(
            children: [
              Text('karma:', style: textStyle),
              Text('_' * 10, style: textStyle),
            ],
          ),
          TableRow(
            children: [
              Text('about:', style: textStyle),
              Text('_' * 10, style: textStyle),
            ],
          ),
          TableRow(
            children: [
              Text(''),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text('_' * 10, style: textStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
