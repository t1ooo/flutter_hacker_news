import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../hacker_news_api/story_type.dart';
import '../provider/provider.dart';
import '../style/style.dart';
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
          ),
          title: Text('Hacker News'),
        ),
        body: TabBarView(
          children: [
            for (final storyType in StoryType.values)
              Padding(
                padding: pagePadding,
                child: MultiProvider(
                  providers: [
                    storyProvider(context),
                    itemProvider(context),
                  ],
                  child: StoriesLoader(storyType: storyType),
                ),
              )
          ],
        ),
      ),
    );
  }
}
