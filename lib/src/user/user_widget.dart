import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../hacker_news_api/user.dart';
import '../user_activities/user_activities_screen.dart';
import '../util/data_time.dart';
import '../widget/html.dart';
import '../widget/link.dart';

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
            Text(_formatItemTime(user.created)),
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
            HtmlText(html: user.about ?? ''),
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
                  routeBuilder: (_) => UserActivitiesScreen(name: user.id),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  static final _dateFormatter = DateFormat('MMMM dd, yyyy');

  String _formatItemTime(int unixTimeSec) {
    final dt = dateTimeFromUnixTime(unixTimeSec);
    return _dateFormatter.format(dt);
  }
}
