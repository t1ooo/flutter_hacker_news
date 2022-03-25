// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../hacker_news_notifier.dart';
import '../item.dart';
import '../style/style.dart';
import 'item_screen.dart';
import 'user.dart';
import 'load_indicator.dart';

// TODO: renmae StoryTile* to Story*
class StoryTileLoader extends StatelessWidget {
  StoryTileLoader({
    Key? key,
    required this.id,
    required this.rank,
    this.showLeading = true,
    this.activeCommentsLink = true,
    this.activeUserLink = true,
  }) : super(key: key);

  final int id;
  final int rank;
  final bool showLeading;
  final bool activeCommentsLink;
  final bool activeUserLink;


  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<HackerNewsNotifier>();

    return FutureBuilder(
      future: notifier.item(id),
      builder: (BuildContext _, AsyncSnapshot<Item> snap) {
        final error = snap.error;
        if (error != null) {
          return onError(context, error, snap.stackTrace);
        }

        final data = snap.data;
        if (data != null) {
          return onData(context, data);
        }

        return onLoading(context);
      },
    );
  }

  Widget onError(BuildContext context, Object? error, StackTrace? st) {
     print(error);
    print(st);
    return Text('fail to load');
  }

  Widget onLoading(BuildContext context) {
    // return LoadIndicator();
    return StoryTilePlaceholder(showLeading: showLeading);
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, Item data) {
    return StoryTile(
      item: data,
      showLeading: showLeading,
      rank: rank,
      activeCommentsLink: activeCommentsLink,
      activeUserLink: activeUserLink,
    );
  }
}

class StoryTilePlaceholder extends StatelessWidget {
  StoryTilePlaceholder({Key? key, required this.showLeading}) : super(key: key);

  final bool showLeading;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      backgroundColor: Colors.white,
    );

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: showLeading ? Text('   ', style: textStyle) : null,
        title: Text('_' * 60, style: textStyle),
        subtitle: Text('_' * 40, style: textStyle),
      ),
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
    this.activeUserLink = true,
  }) : super(key: key);

  final Item item;
  final int rank;
  final bool showLeading;
  final bool activeCommentsLink;
  final bool activeUserLink;

  Widget build(BuildContext context) {
    final title = (item.deleted == true) ? '[deleted]' : (item.title ?? '');

    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: showLeading ? Text('$rank.') : null,
      // trailing: Wrap(children: [Icon(Icons.comment), Text('${item.descendants ?? 0}')]),
      // trailing: Icon(Icons.comment),
      title: Wrap(
        children: [
          InkWell(
            child: Tooltip(child: Text(title, textScaleFactor:1.6), message: item.url ?? '-'),
            onTap: item.url == null ? null : () => launch(item.url!),
          ),
          // if (item.url != null) ...[
          //   Text(' ('),
          //   Text(Uri.parse(item.url!).host),
          //   Text(')'),
          // ],
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
              onTap: activeUserLink ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UserScreen(name: item.by!)),
                );
              } : null,
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
