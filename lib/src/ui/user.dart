import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import '../hacker_news_api.dart';
import '../hacker_news_notifier.dart';
import '../item.dart';
import '../style/style.dart';
import '../user.dart';
import 'comment.dart';
import 'html.dart';
import 'story_tile.dart';
import 'load_indicator.dart';

class UserScreen extends StatelessWidget {
  UserScreen({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UserScreen'),
      ),
      body: Padding(padding: pagePadding, child: UserInfoLoader(name: name)),
    );
  }
}

class UserInfoLoader extends StatelessWidget {
  UserInfoLoader({Key? key, required this.name}) : super(key: key);

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
  }

  void onError(BuildContext context, Object? error) {
    // TODO
  }

  Widget onLoading(BuildContext context) {
    return LoadIndicator();
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, User user) {
    return UserInfo(user: user);
  }
}

class UserInfo extends StatelessWidget {
  UserInfo({Key? key, required this.user}) : super(key: key);

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
            Text(DateTime.fromMillisecondsSinceEpoch(user.created * 1000)
                .toString()),
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
            // Text((user.about ?? '') + "\n"),
            // Html(
            //   data: user.about ?? '',
            //   style: {
            //     "body": Style(
            //       padding: EdgeInsets.zero,
            //       margin: EdgeInsets.zero,
            //     ),
            //   },
            // ),
            HtmlText(html: (user.about ?? '')),
            // Text(user.about == null ? '' : '${user.about}' "\n"),
          ],
        ),
        if (user.submitted != null) ...[
          TableRow(
            children: [
              Text(''),
              Padding(
                padding: const EdgeInsets.only(top:20),
                child: InkWell(
                  child: Text('activity'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            UserActivityScreen(submitted: user.submitted!),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // TableRow(
          //   children: [
          //     Text(''),
          //     InkWell(
          //       child: Text('submissions'),
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (_) =>
          //                 UserSubmissionsScreen(submitted: user.submitted!),
          //           ),
          //         );
          //       },
          //     ),
          //   ],
          // ),
          // TableRow(
          //   children: [
          //     Text(''),
          //     InkWell(
          //       child: Text('comments'),
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (_) =>
          //                 UserCommentsScreen(submitted: user.submitted!),
          //           ),
          //         );
          //       },
          //     ),
          //   ],
          // ),
        ],
      ],
    );
  }
}

class UserActivityScreen extends StatelessWidget {
  UserActivityScreen({Key? key, required this.submitted}) : super(key: key);

  List<int> submitted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UserActivityScreen'),
      ),
      body: Padding(
          padding: pagePadding, child: UserActivity(submitted: submitted)),
    );
  }
}

class UserActivity extends StatelessWidget {
  UserActivity({Key? key, required this.submitted}) : super(key: key);

  List<int> submitted;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<HackerNewsNotifier>();

    return ListView(
      children: [
        for (final id in submitted) // TODO: pagination ?
          // Comment(id: id),
          FutureBuilder(
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
          ),
      ],
    );
  }

  void onError(BuildContext context, Object? error) {
    print(error);
  }

  Widget onLoading(BuildContext context) {
    return LoadIndicator();
  }

  Widget onData(BuildContext context, Item item) {
    // print(item.toJson());
    if (item.type == 'comment') {
      return Comment(item: item, showNested: false);
    } else if (item.type == 'story') {
      return StoryTile(item: item, showLeading: false);
    } else {
      // return StoryTile(item: item, showLeading: false);
      print(item.toJson);
      return Container();
    }
  }
}

// class UserSubmissionsScreen extends StatelessWidget {
//   UserSubmissionsScreen({Key? key, required this.submitted}) : super(key: key);

//   List<int> submitted;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SubmissionsScreen'),
//       ),
//       body: Padding(
//           padding: pagePadding, child: UserSubmissions(submitted: submitted)),
//     );
//   }
// }

// class UserSubmissions extends StatelessWidget {
//   UserSubmissions({Key? key, required this.submitted}) : super(key: key);

//   List<int> submitted;

//   @override
//   Widget build(BuildContext context) {
//     final notifier = context.watch<HackerNewsNotifier>();

//     return ListView(
//       children: [
//         for (final id in submitted)
//           // Comment(id: id),
//           FutureBuilder(
//             future: notifier.item(id),
//             builder: (BuildContext _, AsyncSnapshot<Item> snap) {
//               final error = snap.error;
//               if (error != null) {
//                 onError(context, error);
//               }

//               final data = snap.data;
//               if (data != null) {
//                 if (data.type != 'comment') {
//                   return _StoryTile(item: data);
//                 } else {
//                   return Container();
//                 }
//               }

//               return onLoading(context);
//             },
//           ),
//       ],
//     );
//   }

//   void onError(BuildContext context, Object? error) {
//     print(error);
//     // navigationService.showSnackBarPostFrame(
//     //   error.tr(appLocalizations(context)),
//     // );
//     // TODO
//   }

//   Widget onLoading(BuildContext context) {
//     return LoadIndicator();
//   }
// }

// class UserCommentsScreen extends StatelessWidget {
//   UserCommentsScreen({Key? key, required this.submitted}) : super(key: key);

//   List<int> submitted;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('CommentsScreen'),
//       ),
//       body: Padding(
//           padding: pagePadding, child: UserComments(submitted: submitted)),
//     );
//   }
// }

// class UserComments extends StatelessWidget {
//   UserComments({Key? key, required this.submitted}) : super(key: key);

//   List<int> submitted;

//   @override
//   Widget build(BuildContext context) {
//     final notifier = context.watch<HackerNewsNotifier>();

//     return ListView(
//       children: [
//         for (final id in submitted)
//           // Comment(id: id),
//           FutureBuilder(
//             future: notifier.item(id),
//             builder: (BuildContext _, AsyncSnapshot<Item> snap) {
//               final error = snap.error;
//               if (error != null) {
//                 onError(context, error);
//               }

//               final data = snap.data;
//               if (data != null) {
//                 if (data.type == 'comment') {
//                   return _Comment(
//                     item: data,
//                     showNested: false,
//                   );
//                 } else {
//                   return Container();
//                 }
//               }

//               return onLoading(context);
//             },
//           ),
//       ],
//     );
//   }

//   void onError(BuildContext context, Object? error) {
//     print(error);
//     // navigationService.showSnackBarPostFrame(
//     //   error.tr(appLocalizations(context)),
//     // );
//     // TODO
//   }

//   Widget onLoading(BuildContext context) {
//     return LoadIndicator();
//   }
// }
