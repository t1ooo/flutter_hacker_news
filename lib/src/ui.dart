import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import 'hacker_news_api.dart';
import 'hacker_news_notifier.dart';
import 'item.dart';
import 'style/style.dart';
import 'user.dart';

class TopstoriesView extends StatelessWidget {
  const TopstoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TopstoriesView'),
      ),
      body: Padding(padding: pagePadding, child: ItemList()),
    );
  }
}

class ItemList extends StatelessWidget {
  ItemList({Key? key}) : super(key: key);

  // final hnNotifier = locator<HackerNewsNotifier>()..loadBeststories();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<HackerNewsNotifier>();

    return FutureBuilder(
      future: notifier.beststories(10, 0),
      builder: (BuildContext _, AsyncSnapshot<List<int>> snap) {
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

    // final hnNotifier = context.watch<HackerNewsNotifier>();
    // // final hnNotifier = locator.get<HackerNewsNotifier>();
    // // final hnNotifier = watch<ValueListenable<HackerNewsNotifier>, HackerNewsNotifier>();

    // // final error = watchOnly((HackerNewsNotifier v) => v.error);
    // // final data = watchOnly((HackerNewsNotifier v) => v.beststories);

    // print('rebuild');

    // final error = hnNotifier.error;
    // if (error != null) {
    //   onError(context, error);
    // }

    // final data = hnNotifier.beststories;
    // if (data != null) {
    //   return onData(context, data);
    // }

    // return onLoading(context);

    // return ListView(
    //   children: [
    //     ItemTile(),
    //     ItemTile(),
    //     ItemTile(),
    //     ItemTile(),
    //     ItemTile(),
    //   ],
    // );
  }

  void onError(BuildContext context, Object? error) {
    print(error);
    // navigationService.showSnackBarPostFrame(
    //   error.tr(appLocalizations(context)),
    // );
    // TODO
  }

  Widget onLoading(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, List<int> data) {
    print(data);

    return ListView(
      children: [
        for (final id in data) ItemTile(id: id),
        // ItemTile(),
        // ItemTile(),
        // ItemTile(),
        // ItemTile(),
      ],
    );
  }
}

class ItemTile extends StatelessWidget {
  ItemTile(
      {Key? key,
      required this.id,
      this.showLeading = true,
      this.showText = false})
      : super(key: key);

  final int id;
  final bool showLeading;
  final bool showText;

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

    // final notifier = context.watch<HackerNewsNotifier>();

    // // final error = watchOnly((HackerNewsNotifier v) => v.error);
    // // final data = watchOnly((HackerNewsNotifier v) => v.beststories);

    // final error = notifier.error;
    // if (error != null) {
    //   onError(context, error);
    // }

    // final data = notifier.item;
    // if (data != null) {
    //   return onData(context, data);
    // }

    // return onLoading(context);
  }

  void onError(BuildContext context, Object? error) {
    // navigationService.showSnackBarPostFrame(
    //   error.tr(appLocalizations(context)),
    // );
    // TODO
  }

  Widget onLoading(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, Item data) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: showLeading ? Text('1.') : null,
          title: data.title == null ? Text('-') : Wrap(
            children: [
              // Link(
              //     uri: Uri.parse(
              //         'https://fullstackeconomics.com/why-zillow-is-like-my-bad-fantasy-football-team/'),
              //     builder: (_, __) {
              //       return Text('How Zillow\'s homebuying scheme lost \$881M');
              //     }),
              InkWell(
                // child: Text('How Zillow\'s homebuying scheme lost \$881M'),
                // child: Text(data.title ?? ''),
                child: Text(data.title!),
                // onTap: () {
                //   launch(
                //       'https://fullstackeconomics.com/why-zillow-is-like-my-bad-fantasy-football-team/');
                // },
                onTap: data.url == null ? null : () => launch(data.url!),
              ),
              if (data.url != null) ...[
                Text(' ('),
                Text(Uri.parse(data.url!).host),
                // InkWell(
                //   child: Text('fullstackeconomics.com'),
                //   onTap: () {
                //     launch('https://fullstackeconomics.com/why-zillow-is-like-my-bad-fantasy-football-team/');
                //   },
                // ),
                Text(')'),
              ],
            ],
          ),
          subtitle: Wrap(
            children: [
              if (data.score != null) Text('${data.score} points'),
              if (data.by != null) ...[
                Text(' by '),
                InkWell(
                  child: Text(data.by!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => UserView(name: data.by!)),
                    );
                  },
                ),
              ],
              if (data.time != null) ...[
                Text(' '),
                Text(' ${formatItemTime(data.time!)}'),
                // Text(' ${DateTime.fromMillisecondsSinceEpoch(data.time! * 1000)}'),
                // Text(' 2 hours ago'),
                Text(' | '),
              ],
              InkWell(
                child: Text('${data.descendants ?? 0} comments'),
                // child: Text('comments'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ItemView(id: data.id)),
                  );
                },
              ),
            ],
          ),

          // trailing: Text('1'),
        ),
        if (showText && data.text != null) ...[
          // SizedBox(height: 5),
          Html(
            data: data.text!,
            style: {
              "body": Style(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
              ),
            },
          ),
        ],
      ],
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

class ItemView extends StatelessWidget {
  const ItemView({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ItemView'),
      ),
      body: Padding(padding: pagePadding, child: ItemWidget(id: id)),
    );
  }
}

class ItemWidget extends StatelessWidget {
  ItemWidget({Key? key, required this.id}) : super(key: key);

  final int id;

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

    // final notifier = context.watch<HackerNewsItemNotifier>();

    // // final error = watchOnly((HackerNewsNotifier v) => v.error);
    // // final data = watchOnly((HackerNewsNotifier v) => v.beststories);

    // final error = notifier.error;
    // if (error != null) {
    //   onError(context, error);
    // }

    // final data = notifier.item;
    // if (data != null) {
    //   return onData(context, data);
    // }

    // return onLoading(context);
  }

  void onError(BuildContext context, Object? error) {
    // navigationService.showSnackBarPostFrame(
    //   error.tr(appLocalizations(context)),
    // );
    // TODO
  }

  Widget onLoading(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, Item data) {
    return ListView(
      children: [
        // TODO: fix: item load twice
        ItemTile(id: data.id, showLeading: false),
        SizedBox(height: 20),
        // TextField(
        //   maxLines: 8,
        //   decoration: InputDecoration(
        //     border: OutlineInputBorder(),
        //     hintText: 'Enter a search term',
        //   ),
        // ),
        // SizedBox(height: 10),
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       minimumSize: Size(50, 40), //////// HERE
        //     ),
        //     onPressed: () => {},
        //     child: Text('add comment'),
        //   ),
        // ),

        // Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // children: [

        for (final id in data.kids ?? []) Comment(id: id),
      ],
    );
  }
}

// TODO: MAYBE: sptit to CommentLoader and Comment
class Comment extends StatelessWidget {
  const Comment({Key? key, required this.id, this.depth = 0}) : super(key: key);

  final int id;
  final int depth;
  static const maxDepth = 5;

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

    // final notifier = context.watch<HackerNewsItemNotifier>();

    // // final error = watchOnly((HackerNewsNotifier v) => v.error);
    // // final data = watchOnly((HackerNewsNotifier v) => v.beststories);

    // final error = notifier.error;
    // if (error != null) {
    //   onError(context, error);
    // }

    // final data = notifier.item;
    // if (data != null) {
    //   return onData(context, data);
    // }

    // return onLoading(context);
  }

  void onError(BuildContext context, Object? error) {
    // navigationService.showSnackBarPostFrame(
    //   error.tr(appLocalizations(context)),
    // );
    // TODO
  }

  Widget onLoading(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, Item data) {
    final leftPadding = min(depth, maxDepth) * 30.0;
    final textStyle = TextStyle(color: Colors.grey);

    return Container(
      child: Padding(
        // padding: const EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.only(left: leftPadding, top: 5, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                if (data.by != null) ...[
                  InkWell(
                    child: Text(data.by!, style: textStyle),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => UserView(name: data.by!)),
                      );
                    },
                  ),
                ],
                // InkWell(
                //   child: Text('spockz'),
                //   onTap: () {
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (_) => ItemView()));
                //   },
                // ),
                // Text(' '),
                if (data.time != null) ...[
                  Text(' '),
                  Text(' ${formatItemTime(data.time!)}', style: textStyle),
                  // Text(' ${DateTime.fromMillisecondsSinceEpoch(data.time! * 1000)}'),
                  // Text(' 2 hours ago'),
                  Text(' | '),
                ],
                // InkWell(
                //   child: Text('11 minutes ago'),
                //   onTap: () {
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (_) => ItemView()));
                //   },
                // ),
                // Text(' | '),
                Text('prev', style: textStyle),
                Text(' | ', style: textStyle),
                Text('next [–]', style: textStyle),
              ],
            ),

            // if (data.text != null) Align(
            //   alignment: Alignment.topLeft,
            //   child:
            //     Html(data: data.text),

            // ),

            if (data.text != null) ...[
              // SizedBox(height: 5),
              Html(
                data: data.text!,
                style: {
                  "body": Style(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                  ),
                },
              ),
            ],
            // Text('spockz 11 minutes ago | next [–]'),
            // Text(
            //     'What are the benefits of running (open)BSD on a workstation? Especially a laptop?'),
            // Text(
            //     'Edit: this could of course also be used for running a server on a M1 mini! '),
            for (final id in data.kids ?? []) Comment(id: id, depth: depth + 1)
          ],
        ),
      ),
    );
  }
}

class CommentBorder extends StatelessWidget {
  const CommentBorder({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(width: 1.0, color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: child,
      ),
    );
  }
}

class UserView extends StatelessWidget {
  const UserView({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UserView'),
      ),
      body: Padding(padding: pagePadding, child: UserWidget(name: name)),
    );
  }
}

class UserWidget extends StatelessWidget {
  UserWidget({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<HackerNewsNotifier>();

    return FutureBuilder(
      future: notifier.user(name),
      builder: (BuildContext _, AsyncSnapshot<User> snap) {
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

    // final notifier = context.watch<HackerNewsItemNotifier>();

    // // final error = watchOnly((HackerNewsNotifier v) => v.error);
    // // final data = watchOnly((HackerNewsNotifier v) => v.beststories);

    // final error = notifier.error;
    // if (error != null) {
    //   onError(context, error);
    // }

    // final data = notifier.item;
    // if (data != null) {
    //   return onData(context, data);
    // }

    // return onLoading(context);
  }

  void onError(BuildContext context, Object? error) {
    // navigationService.showSnackBarPostFrame(
    //   error.tr(appLocalizations(context)),
    // );
    // TODO
  }

  Widget onLoading(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, User data) {
    // return ListView(
    //   children: [
    //     Text('user:	brynet'),
    //     Text('created:	May 18, 2013'),
    //     Text('karma:	1804'),
    //     Text('about:	I occasionally hack on OpenBSD and ramble on twitter @canadianbryan.'),

    //        Text('submissions'),
    //        Text('comments'),
    //        Text('favorites'),
    //   ],
    // );

    // return GridView.count(
    //   // Create a grid with 2 columns. If you change the scrollDirection to
    //   // horizontal, this produces 2 rows.
    //   crossAxisCount: 2,
    //   // Generate 100 widgets that display their index in the List.
    //   children: [
    //     Text('1'),
    //     Text('2'),
    //     Text('3'),
    //   ],
    // );

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(flex: 0.15),
        1: FlexColumnWidth(),
      },
      children: [
        TableRow(
          children: [
            Text('user:'),
            Text(data.id),
          ],
        ),
        TableRow(
          children: [
            Text('created:'),
            Text(DateTime.fromMillisecondsSinceEpoch(data.created * 1000)
                .toString()),
          ],
        ),
        TableRow(
          children: [
            Text('karma:'),
            Text('${data.karma}'),
          ],
        ),
        TableRow(
          children: [
            Text('about:'),
            Text((data.about ?? '') + "\n"),
          ],
        ),
        if (data.submitted != null)
          TableRow(
            children: [
              Text(''),
              InkWell(
                child: Text('submissions'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              SubmissionsView(submitted: data.submitted!)));
                },
              ),
            ],
          ),
        // TableRow(
        //   children: [
        //     Text(''),
        //     InkWell(
        //       child: Text('comments'),
        //       onTap: () {
        //         Navigator.push(
        //             context, MaterialPageRoute(builder: (_) => CommentsView()));
        //       },
        //     ),
        //   ],
        // ),
        // TableRow(
        //   children: [
        //     Text(''),
        //     InkWell(
        //       child: Text('favorites'),
        //       onTap: () {
        //         Navigator.push(context,
        //             MaterialPageRoute(builder: (_) => FavoritesView()));
        //       },
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class SubmissionsView extends StatelessWidget {
  SubmissionsView({Key? key, required this.submitted}) : super(key: key);

  List<int> submitted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SubmissionsView'),
      ),
      body: Padding(
          padding: pagePadding, child: Submissions(submitted: submitted)),
    );
  }
}

class Submissions extends StatelessWidget {
  Submissions({Key? key, required this.submitted}) : super(key: key);

  List<int> submitted;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final id in submitted) ItemTile(id: id, showLeading: false, showText:true),
        // ItemTile(),
        // ItemTile(),
        // ItemTile(),
        // ItemTile(),
      ],
    );
  }
}

// class CommentsView extends StatelessWidget {
//   const CommentsView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('CommentsView'),
//       ),
//       body: Padding(padding: pagePadding, child: TodoWidget()),
//     );
//   }
// }

// class FavoritesView extends StatelessWidget {
//   const FavoritesView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('FavoritesView'),
//       ),
//       body: Padding(padding: pagePadding, child: TodoWidget()),
//     );
//   }
// }

class TodoWidget extends StatelessWidget {
  const TodoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('TODO');
  }
}
