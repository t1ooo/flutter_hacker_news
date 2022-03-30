import 'package:flutter/material.dart';
import 'package:flutter_hacker_news_prototype/src/widget/loading_placeholder.dart';
import 'package:shimmer/shimmer.dart';

class UserPlaceholder extends StatelessWidget {
  UserPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return LoadingPlaceholder(height: 200);
    // return Padding(padding: storyTilePadding, child: LoadingPlaceholder());

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
              Text('_' * 500, style: textStyle),
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
