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




class UserWidget extends StatelessWidget {
  UserWidget({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(flex: 0.15),
        1: FlexColumnWidth(),
      },
      children: [
        TableRow(
          children: [
            Text('user:'),
            Text(user.id),
          ],
        ),
        TableRow(
          children: [
            Text('created:'),
            Text(DateTime.fromMillisecondsSinceEpoch(user.created * 1000)
                .toString()),
          ],
        ),
        TableRow(
          children: [
            Text('karma:'),
            Text('${user.karma}'),
          ],
        ),
        TableRow(
          children: [
            Text('about:'),
            // Text((user.about ?? '') + "\n"),
            // Html(
            //   data: user.about ?? '',
            //   style: {
            //     "body": Style(
            //       padding: EdgeInsets.zero,
            //       margin: EdgeInsets.zero,
            //     ),
            //   },
            // ),
            HtmlText(html: (user.about ?? '')),
            // Text(user.about == null ? '' : '${user.about}' "\n"),
          ],
        ),
        if (user.submitted != null) ...[
          TableRow(
            children: [
              Text(''),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                // child: InkWell(
                //   child: Text('activity'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) =>
                //             // UserActivityScreen(submitted: user.submitted!),
                //             UserActivityScreen(name: user.id),
                //       ),
                //     );
                //   },
                // ),
                child: MaterialAppLink(
                  child: Text('activity'),
                  // child: Text('comments'),
                  routeBuilder: (_) => UserActivityScreen(name: user.id),
                ),
              ),
            ],
          ),
          // TableRow(
          //   children: [
          //     Text(''),
          //     InkWell(
          //       child: Text('submissions'),
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (_) =>
          //                 UserSubmissionsScreen(submitted: user.submitted!),
          //           ),
          //         );
          //       },
          //     ),
          //   ],
          // ),
          // TableRow(
          //   children: [
          //     Text(''),
          //     InkWell(
          //       child: Text('comments'),
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (_) =>
          //                 UserCommentsScreen(submitted: user.submitted!),
          //           ),
          //         );
          //       },
          //     ),
          //   ],
          // ),
        ],
      ],
    );
  }
}
