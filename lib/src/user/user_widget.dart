import 'package:flutter/material.dart';

import '../hacker_news_api/user.dart';
import '../widget/html.dart';
import '../widget/link.dart';
import '../user_activity/user_activity_screen_v2.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({Key? key, required this.user}) : super(key: key);

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
                .toString(),), // TODO: format
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
            HtmlText(html: (user.about ?? '')),
          ],
        ),
        if (user.submitted != null) ...[
          TableRow(
            children: [
              Text(''),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: MaterialAppLink(
                  child: Text('activity'),
                  routeBuilder: (_) => UserActivityScreen(name: user.id),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
