import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import '../hacker_news_api.dart';
import '../style/style.dart';
import 'stories.dart';
import 'stories_controller.dart';

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
          title: Text('StoriesScreen'),
        ),
        // body: Padding(padding: pagePadding, child: ItemList()),
        body: TabBarView(
          children: [
            for (final storyType in StoryType.values)
              Padding(
                padding: pagePadding,
                child: ChangeNotifierProvider(
                  create: (BuildContext context) =>
                      StoriesController(context.read<HackerNewsApi>())
                        ..loadStoryIds(storyType),
                  child: Stories(storyType: storyType),
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
