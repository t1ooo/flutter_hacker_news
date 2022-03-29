import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import '../hacker_news_api/hacker_news_api.dart';
import '../hacker_news_api/story_type.dart';
import '../notifier/item_notifier.dart';
import '../notifier/story_notifier.dart';
import '../style/style.dart';
import 'stories.dart';
import 'stories_loader.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: StoryType.values.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              for (final storyType in StoryType.values)
                Tab(text: storyType.toText())
            ],
            // labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
          title: Text('Hacker News'),
        ),
        // body: Padding(padding: pagePadding, child: ItemList()),
        body: TabBarView(
          children: [
            for (final storyType in StoryType.values)
              Padding(
                padding: pagePadding,
                child: /*  ChangeNotifierProvider(
                  create: (BuildContext context) =>
                      StoryNotifier(context.read<HackerNewsApi>())
                        ..loadStoryIds(storyType),
                  child: Stories(storyType: storyType),
                ), */
                    MultiProvider(
                  providers: [
                    // TODO: move providers to function
                    // storyProvider(context)  => ...
                    ChangeNotifierProvider(
                        create: (BuildContext context) =>
                            StoryNotifier(context.read<HackerNewsApi>())
                        // ..loadStoryIds(storyType),
                        ),
                    ChangeNotifierProvider(
                      create: (BuildContext context) =>
                          ItemNotifier(context.read<HackerNewsApi>()),
                    ),
                  ],
                  // child: Stories(storyType: storyType),
                  child: StoriesLoader(storyType: storyType),
                ),
              )
          ],
          // ),
        ),
      ),
    );
  }
}

// class StoriesScreen extends StatelessWidget {
//   const StoriesScreen({Key? key}) : super(key: key);

//   static const _tabs = [
//     'top ',
//     'new',
//     'bests',
//     'ask',
//     'show',
//     'job',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stories'),
//       ),
//       body: Padding(padding: pagePadding, child: ItemList()),
//     );
//   }
// }
