import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import '../hacker_news_api.dart';
import '../hacker_news_notifier.dart';
import '../item.dart';
import '../story/comment.dart';
import '../style/style.dart';
import '../ui/html.dart';
import '../user.dart';
import '../user_activity/user_activity_screen.dart';
import 'user_controller.dart';

class UserScreen extends StatelessWidget {
  UserScreen({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UserScreen'),
      ),
      body: Padding(
        padding: pagePadding,
        child: ChangeNotifierProvider(
          create: (BuildContext context) =>
              UserController(context.read<HackerNewsApi>())..loadUser(name),
          child: UserLoader(name: name),
        ),
      ),
    );
  }
}

class UserLoader extends StatelessWidget {
  // TODO: remove name
  UserLoader({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final userR = context.select<UserController, UserResult>((v) => v.user);

    final error = userR.error;
    if (error != null) {
      return onError(context, error);
    }

    final value = userR.value;
    if (value != null) {
      return onData(context, value);
    }

    return onLoading(context);
  }

  Widget onError(BuildContext context, Object? error) {
    return Text(error.toString());
  }

  Widget onLoading(BuildContext context) {
    return UserPlaceholder();
    // return Container();
  }

  // Widget build(BuildContext context) {
  Widget onData(BuildContext context, User user) {
    return UserWidget(user: user);
  }
}

class UserWidget extends StatelessWidget {
  UserWidget({Key? key, required this.user}) : super(key: key);

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
                padding: const EdgeInsets.only(top: 20),
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

class UserPlaceholder extends StatelessWidget {
  UserPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      backgroundColor: Colors.white,
    );

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(flex: 0.15),
          1: FlexColumnWidth(),
        },
        children: [
          TableRow(
            children: [
              Text('user:', style: textStyle), // TODO: move to widget
              Text('_' * 10, style: textStyle),
            ],
          ),
          TableRow(
            children: [
              Text('created:', style: textStyle),
              Text('_' * 10, style: textStyle),
            ],
          ),
          TableRow(
            children: [
              Text('karma:', style: textStyle),
              Text('_' * 10, style: textStyle),
            ],
          ),
          TableRow(
            children: [
              Text('about:', style: textStyle),
              Text('_' * 10, style: textStyle),
            ],
          ),
          TableRow(
            children: [
              Text(''),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text('_' * 10, style: textStyle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class UserActivityScreen extends StatelessWidget {
//   UserActivityScreen({Key? key, required this.submitted}) : super(key: key);

//   List<int> submitted;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('UserActivityScreen'),
//       ),
//       body: Padding(
//           padding: pagePadding, child: UserActivityList(submitted: submitted)),
//     );
//   }
// }

// class UserActivityList extends StatelessWidget {
//   UserActivityList({Key? key, required this.submitted}) : super(key: key);

//   List<int> submitted;

//   @override
//   Widget build(BuildContext context) {
//     // final notifier = context.watch<HackerNewsNotifier>();

//     return onData(context, submitted);

//     // return FutureBuilder(
//     //   future: Future.delayed(Duration(seconds: 1), () => submitted),
//     //   builder: (BuildContext _, AsyncSnapshot<List<int>> snap) {
//     //     // final error = snap.error;
//     //     // if (error != null) {
//     //     //   onError(context, error);
//     //     // }

//     //     final data = snap.data;
//     //     if (data != null) {
//     //       return onData(context, data);
//     //     }

//     //     return onLoading(context);
//     //   },
//     // );

//     // return ListView(
//     //   children: [
//     //     for (final id in submitted.take(10)) // TODO: pagination ?
//     //       // Comment(id: id),
//     //       FutureBuilder(
//     //         future: notifier.item(id),
//     //         builder: (BuildContext _, AsyncSnapshot<Item> snap) {
//     //           final error = snap.error;
//     //           if (error != null) {
//     //             return onError(context, error, snap.stackTrace);
//     //           }

//     //           final data = snap.data;
//     //           if (data != null) {
//     //             return onData(context, data);
//     //           }

//     //           return onLoading(context);
//     //         },
//     //       ),
//     //   ],
//     // );
//   }

//   void onError(BuildContext context, Object? error, StackTrace? st) {
//     print(error);
//   }

//   Widget onLoading(BuildContext context) {
//     // return LoadIndicator();
//     return ListView(
//       children: [for (int i = 0; i < 20; i++) CommentPlaceholder(depth: 0)],
//     );
//   }

//   Widget onData(BuildContext context, List<int> data) {
//     return ListView(
//       // cacheExtent: 1.5,
//       children: [
//         // for (final id in data)  StoryTile(id: id, rank: rank)
//         for (int id in data)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: UserActivityLoader(id: id),
//           )
//       ],
//     );
//   }
// }

// class UserActivityLoader extends StatelessWidget {
//   UserActivityLoader({Key? key, required this.id}) : super(key: key);

//   final int id;

//   @override
//   Widget build(BuildContext context) {
//     print(id);
//     // return CommentPlaceholder();
//     final notifier = context.watch<HackerNewsNotifier>();

//     return FutureBuilder(
//       future: notifier.item(id),
//       builder: (BuildContext _, AsyncSnapshot<Item> snap) {
//         final error = snap.error;
//         if (error != null) {
//           return onError(context, error, snap.stackTrace);
//         }

//         final data = snap.data;
//         if (data != null) {
//           return onData(context, data);
//         }

//         return onLoading(context);
//       },
//     );
//   }

//   Widget onError(BuildContext context, Object? error, StackTrace? st) {
//     print(error);
//     print(st);
//     return Text('fail to load');
//   }

//   Widget onLoading(BuildContext context) {
//     // return LoadIndicator();
//     return CommentPlaceholder(depth: 0);
//   }

//   Widget onData(BuildContext context, Item item) {
//     return Container();
//     // print(item.toJson());
//     if (item.type == 'comment') {
//       return Comment(item: item, showNested: false, activeUserLink: false);
//     } else if (item.type == 'story') {
//       // return StoryTile(item: item, showLeading: false, activeUserLink: false);
//     } else {
//       // return StoryTile(item: item, showLeading: false);
//       print(item.toJson);
//       return Container();
//     }
//   }
// }

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
//                 return onError(context, error, snap.stackTrace);
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

//   Widget onError(BuildContext context, Object? error, StackTrace? st) {
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
//                 return onError(context, error, snap.stackTrace);
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

//   Widget onError(BuildContext context, Object? error, StackTrace? st) {
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
