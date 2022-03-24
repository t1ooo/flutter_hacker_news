// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../hacker_news_notifier.dart';
import '../item.dart';
import '../style/style.dart';
import 'item_screen.dart';
import 'user.dart';
import 'load_indicator.dart';

class StoryTileLoader extends StatelessWidget {
  StoryTileLoader({
    Key? key,
    required this.id,
    required this.rank,
    this.showLeading = true,
    this.activeCommentsLink = true,
  }) : super(key: key);

  final int id;
  final int rank;
  final bool showLeading;
  final bool activeCommentsLink;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<HackerNewsNotifier>();

    return FutureBuilder(
      future: notifier.item(id),
      builder: (BuildContext _, AsyncSnapshot<Item> snap) {
        final error = snap.error;
        if (error != null) {
          onError(context, error);
        }

        final data = snap.data;
        if (data != null) {
          return onData(context, data);
        }

        return onLoading(context);
      },
    );
  }

  void onError(BuildContext context, Object? error) {
    // TODO
  }

  Widget onLoading(BuildContext context) {
    return LoadIndicator();
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, Item data) {
    return StoryTile(
      item: data,
      showLeading: showLeading,
      rank: rank,
      activeCommentsLink: activeCommentsLink,
    );
  }
}

class StoryTile extends StatelessWidget {
  StoryTile({
    Key? key,
    required this.item,
    this.rank = 0,
    this.showLeading = true,
    this.activeCommentsLink = true,
  }) : super(key: key);

  final Item item;
  final int rank;
  final bool showLeading;
  final bool activeCommentsLink;

  Widget build(BuildContext context) {
    final title = (item.deleted == true) ? '[deleted]' : (item.title ?? '');

    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: showLeading ? Text('$rank.') : null,
      title: Wrap(
        children: [
          InkWell(
            child: Text(title),
            onTap: item.url == null ? null : () => launch(item.url!),
          ),
          if (item.url != null) ...[
            Text(' ('),
            Text(Uri.parse(item.url!).host),
            Text(')'),
          ],
        ],
      ),
      subtitle: Wrap(
        children: [
          if (item.score != null) ...[
            Text('${item.score} points'),
            Text(' '),
          ],
          if (item.by != null) ...[
            Text('by '),
            InkWell(
              child: Text(item.by!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UserScreen(name: item.by!)),
                );
              },
            ),
            Text(' '),
          ],
          if (item.time != null) ...[
            Text(formatItemTime(item.time!)),
            Text(' | '),
          ],
          InkWell(
            child: Text('${item.descendants ?? 0} comments'),
            // child: Text('comments'),
            onTap: activeCommentsLink
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ItemScreen(id: item.id)),
                    );
                  }
                : null,
          ),
        ],
      ),

      // trailing: Text('1'),
    );
  }
}

String formatItemTime(int unixTimeS) {
  final diff = DateTime.now()
      .toUtc()
      .difference(DateTime.fromMillisecondsSinceEpoch(unixTimeS * 1000));
  if (diff.inDays > 0) {
    return '${diff.inDays} days ago';
  }
  if (diff.inHours > 0) {
    return '${diff.inHours} hours ago';
  }

  return '${diff.inMinutes} minutes ago';
}
