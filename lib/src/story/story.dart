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
import '../ui/builder.dart._';
import '../ui/swipe_to_refresh.dart';
import 'comment_loader.dart';
import 'comments_placeholder.dart';
import 'story_tile.dart';
import '../style/style.dart';
import 'comment.dart';

// class Story extends StatelessWidget {
//   Story({Key? key, required this.id}) : super(key: key);

//   final int id;

//   @override
//   Widget build(BuildContext context) {
//     // final notifier = context.watch<HackerNewsNotifier>();
//     final storyR = context.select<ItemNotifier, ItemResult>((v) => v.item(id));

//     final error = storyR.error;
//     if (error != null) {
//       return onError(context, error);
//     }

//     final value = storyR.value;
//     if (value != null) {
//       return onData(context, value);
//     }

//     return onLoading(context);
//   }

//   Widget onError(BuildContext context, Object? error) {
//     return Text(e.toString());
//   }

//   // Widget onLoading(BuildContext context) {
//   //   return ListView(
//   //     children: [
//   //       // TODO: fix: item load twice
//   //       StoryTilePlaceholder(showLeading: false),
//   //       SizedBox(height: 20),
//   //       // for (final id in data.kids ?? []) CommentLoader(id: id),
//   //       for (int i = 0; i < 20; i++) CommentPlaceholder(depth: 0)
//   //     ],
//   //   );
//   // }

//   Widget onLoading(BuildContext context) {
//     // return ListView.builder(
//     //   itemCount: 20,
//     //   itemBuilder: (_, __) {
//     //     return CommentPlaceholder(depth: 0);
//     //   },
//     // );

//     // return ListView(children: [
//     //   for (int i = 0; i < 20; i++) CommentPlaceholder(depth: 0),
//     // ]);
//     return CommentsPlaceholder();
//   }

//   // Widget build(BuildContext context) {
//   Widget onData(BuildContext context, Item item) {
//     return SwipeToRefresh(
//       onRefresh: () async {
//         // return context.read<ItemNotifier>().reloadItem(item.id);
//         context.read<ItemNotifier>().reloadItems();
//       },
//       child: ListView(
//         children: [
//           // TODO: fix: item load twice
//           // StoryTileLoader(
//           //   id: item.id,
//           //   rank: 0,
//           //   showLeading: false,
//           //   activeCommentsLink: false,
//           // ),

//           StoryTile(
//             item: item,
//             rank: 0,
//             showLeading: false,
//             activeCommentsLink: false,
//           ),

//           SizedBox(height: 20),

//           // if (data.kids != null)
//           //   ListView.builder(
//           //     shrinkWrap: true,
//           //     itemCount: data.kids!.length,
//           //     itemBuilder: (_, int i) {
//           //       final id = data.kids![i];
//           //       context.read<ItemNotifier>().loadItem(id);
//           //       return CommentLoader(id: id);
//           //     },
//           //   ),

//           // if (data.kids != null)
//           //   ListView(children: [
//           //     for (var id in data.kids!)
//           //       Builder(builder: (_) {
//           //         context.read<ItemNotifier>().loadItem(id);
//           //         return CommentLoader(id: id);
//           //       })
//           //   ])

//           if (item.kids != null)
//             for (var id in item.kids!)
//               // Builder(builder: (_) {
//               //   context.read<ItemNotifier>().loadItem(id);
//               //   return CommentLoader(id: id);
//               // })
//               CommentLoaderV2(
//                   id: id,
//                   onData: (_, Item item) {
//                     return Comment(
//                       item: item,
//                     );
//                   })
//         ],
//       ),
//     );
//   }
// }

class StoryLoader extends StatelessWidget {
  StoryLoader({Key? key, required this.id, this.onData}) : super(key: key);

  final int id;
  final Widget Function(BuildContext, Item)? onData;

  Widget build(BuildContext context) {
    return InitBuilder(
      initState: () => context.read<ItemNotifier>().loadItem(id),
      builder: builder,
    );

    // return FutureBuilder(
    //   future: context.read<ItemNotifier>().loadItem(id),
    //   builder: (BuildContext context, _ ) => builder(context),
    // );

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   context.read<StoryNotifier>().loadStoryIds(storyType);
    // });
    // return builder(context);
  }

  @override
  Widget builder(BuildContext context) {
    // final notifier = context.watch<HackerNewsNotifier>();
    final storyR = context.select<ItemNotifier, ItemResult>((v) => v.item(id));

    final error = storyR.error;
    if (error != null) {
      return onError(context, error);
    }

    final value = storyR.value;
    if (value != null) {
      return _onData(context, value);
    }

    return onLoading(context);
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(e.toString());
  }

  Widget onLoading(BuildContext context) {
    // return ListView.builder(
    //   itemCount: 20,
    //   itemBuilder: (_, __) {
    //     return CommentPlaceholder(depth: 0);
    //   },
    // );

    // return ListView(children: [
    //   for (int i = 0; i < 20; i++) CommentPlaceholder(depth: 0),
    // ]);
    return CommentsPlaceholder();
  }

  // Widget build(BuildContext context) {
  Widget _onData(BuildContext context, Item item) {
    return SwipeToRefresh(
      onRefresh: () async {
        // return context.read<ItemNotifier>().reloadItem(item.id);
        context.read<ItemNotifier>().reloadItems();
      },
      child: (onData ?? defaultOnData)(context, item),
    );
  }

  Widget defaultOnData(BuildContext context, Item item) {
    return Story(item: item);
  }
}

class Story extends StatelessWidget {
  Story({Key? key, required this.item}) : super(key: key);

  final Item item;

  Widget build(BuildContext context) {
    return SwipeToRefresh(
      onRefresh: () async {
        // return context.read<ItemNotifier>().reloadItem(item.id);
        context.read<ItemNotifier>().reloadItems();
      },
      child: ListView(
        children: [
          // TODO: fix: item load twice
          // StoryTileLoader(
          //   id: item.id,
          //   rank: 0,
          //   showLeading: false,
          //   activeCommentsLink: false,
          // ),

          StoryTile(
            item: item,
            rank: 0,
            showLeading: false,
            activeCommentsLink: false,
          ),

          SizedBox(height: 20),

          // if (data.kids != null)
          //   ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: data.kids!.length,
          //     itemBuilder: (_, int i) {
          //       final id = data.kids![i];
          //       context.read<ItemNotifier>().loadItem(id);
          //       return CommentLoader(id: id);
          //     },
          //   ),

          // if (data.kids != null)
          //   ListView(children: [
          //     for (var id in data.kids!)
          //       Builder(builder: (_) {
          //         context.read<ItemNotifier>().loadItem(id);
          //         return CommentLoader(id: id);
          //       })
          //   ])

          if (item.kids != null)
            for (var id in item.kids!)
              // Builder(builder: (_) {
              //   context.read<ItemNotifier>().loadItem(id);
              //   return CommentLoader(id: id);
              // })
              CommentLoaderV2(
                  id: id,
                  onData: (_, Item item) {
                    return Comment(
                      item: item,
                    );
                  })
        ],
      ),
    );
  }
}
