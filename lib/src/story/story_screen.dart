import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/item.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/item_notifier.dart';
import 'story.dart';
import 'story_tile.dart';
import '../style/style.dart';
import 'comment.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story'),
      ),
      body: Padding(
        padding: pagePadding,
        // child: Story(id: id),
        // child: ChangeNotifierProvider(
        //   create: (BuildContext context) =>
        //       ItemNotifier(context.read<HackerNewsApi>())..loadItem(id),
        //   child: Story(id: id),
        // ),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (BuildContext context) =>
                  ItemNotifier(context.read<HackerNewsApi>())..loadItem(id),
            ),
            ChangeNotifierProvider(
              create: (BuildContext context) => CommentNotifier(),
            ),
          ],
          child: Story(id: id),
        ),
      ),
    );
  }
}

// class StoryScreen extends StatelessWidget {
//   const StoryScreen({Key? key, required this.id}) : super(key: key);

//   final int id;

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (BuildContext context) =>
//               ItemNotifier(context.read<HackerNewsApi>())..loadItem(id),
//         ),
//         ChangeNotifierProvider(
//           create: (BuildContext context) => CommentNotifier(),
//         ),
//       ],
//       child: builder(context),
//     );
//   }

//   Widget builder(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // title: Text('StoryScreen'),
//         title: StoryTitle(id: id),
//       ),
//       body: Padding(
//         padding: pagePadding,
//         // child: Story(id: id),
//         // child: ChangeNotifierProvider(
//         //   create: (BuildContext context) =>
//         //       ItemNotifier(context.read<HackerNewsApi>())..loadItem(id),
//         //   child: Story(id: id),
//         // ),
//         child: Story(id: id),
//       ),
//     );
//   }
// }

// class StoryTitle extends StatelessWidget {
//   StoryTitle({Key? key, required this.id}) : super(key: key);

//   final int id;

//   @override
//   Widget build(BuildContext context) {
//     final itemR = context.select<ItemNotifier, ItemResult>((v) => v.item(id));

//     final error = itemR.error;
//     if (error != null) {
//       return onError(context, error);
//     }

//     final value = itemR.value;
//     if (value != null) {
//       return onData(context, value);
//     }

//     return onLoading(context);
//   }

//   Widget onError(BuildContext context, Object? error) {
//     return Text(error.toString());
//   }

//   Widget onLoading(BuildContext context) {
//     return Text('TODO');
//   }

//   Widget onData(BuildContext context, Item item) {
//     return Text(item.title ?? '');
//   }
// }
