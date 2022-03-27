// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../hacker_news_notifier.dart';
import '../hacker_news_api/item.dart';
import '../notifier/item_notifier.dart';
import '../story/story_screen.dart';
import '../style/style.dart';
// import '../ui/item_screen.dart';
// import '../ui/user.dart';
import '../ui/link.dart';
import '../user/user_screen.dart';
import 'format_time.dart';
// import 'story_controller.dart';

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
    // final controller = context.watch<StoriesController>();
    final item = context.select<ItemNotifier, ItemResult>((v) => v.item(id));

    // final item = controller.item(id);
    final error = item.error;
    if (error != null) {
      return onError(context, error);
    }

    final value = item.value;
    if (value != null) {
      return onData(context, value);
    }

    return onLoading(context);
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
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

class StoryTileLoaderV2 extends StatefulWidget {
  StoryTileLoaderV2({
    Key? key,
    required this.id,
    required this.onData,
    this.showLeading = true,
  }) : super(key: key);

  final int id;
  final Widget Function(BuildContext, Item) onData;
  final bool showLeading;

  @override
  State<StoryTileLoaderV2> createState() => _StoryTileLoaderV2State();
}

class _StoryTileLoaderV2State extends State<StoryTileLoaderV2> {
  @override
  void initState() {
    context.read<ItemNotifier>().loadItem(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = context.watch<StoriesController>();
    final item =
        context.select<ItemNotifier, ItemResult>((v) => v.item(widget.id));

    // final item = controller.item(id);
    final error = item.error;
    if (error != null) {
      return onError(context, error);
    }

    final value = item.value;
    if (value != null) {
      return widget.onData(context, value);
    }

    return onLoading(context);
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return StoryTilePlaceholder(showLeading: widget.showLeading);
  }
}

class StoryTilePlaceholder extends StatelessWidget {
  StoryTilePlaceholder({Key? key, required this.showLeading}) : super(key: key);

  final bool showLeading;

  @override
  Widget build(BuildContext context) {
    // TODO: extract to placeholder.dart
    final textStyle = TextStyle(
      color: Colors.white,
      backgroundColor: Colors.white,
    );

    // extract to placeholder.dart
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding:
            EdgeInsets.only(top: _storyTilePadding, bottom: _storyTilePadding),
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: showLeading ? Text('   ', style: textStyle) : null,
          title: Text('_' * 60, style: textStyle),
          subtitle: Text('_' * 40, style: textStyle),
        ),
      ),
    );
  }
}

const _storyTilePadding = 10.0;

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

    return Padding(
      padding:
          EdgeInsets.only(top: _storyTilePadding, bottom: _storyTilePadding),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: showLeading ? Text('$rank.') : null,
        // trailing: Wrap(children: [Icon(Icons.comment), Text('${item.descendants ?? 0}')]),
        // trailing: Icon(Icons.comment),
        title: Wrap(
          children: [
            if (item.url != null)
              WebLink(
                child: Text(title, textScaleFactor: 1.6),
                url: item.url!,
              )
            else
              // Text(title, textScaleFactor: 1.6)
              MaterialAppLink(
                child: Text(title, textScaleFactor: 1.6),
                // child: Text('comments'),
                routeBuilder: (_) => StoryScreen(id: item.id),
              ),
          ],
        ),
        subtitle: Wrap(
          children: [
            if (item.score != null) ...[
              Text('${item.score} points '),
            ],
            if (item.by != null) ...[
              Text('by '),
              MaterialAppLink(
                child: Text(item.by!),
                routeBuilder: (_) => UserScreen(name: item.by!),
                active: activeUserLink,
              ),
              Text(' '),
            ],
            if (item.time != null) ...[
              Text(formatItemTime(item.time!) + ' | '),
            ],
            MaterialAppLink(
              child: Text('${item.descendants ?? 0} comments'),
              // child: Text('comments'),
              routeBuilder: (_) => StoryScreen(id: item.id),
              active: activeCommentsLink,
            ),
          ],
        ),

        // trailing: Text('1'),
      ),
    );
  }
}

// String formatItemTime(int unixTimeS) {
//   final diff = DateTime.now()
//       .toUtc()
//       .difference(DateTime.fromMillisecondsSinceEpoch(unixTimeS * 1000));
//   if (diff.inDays > 0) {
//     return '${diff.inDays} days ago';
//   }
//   if (diff.inHours > 0) {
//     return '${diff.inHours} hours ago';
//   }

//   return '${diff.inMinutes} minutes ago';
// }
