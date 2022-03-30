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
    
    final text = Text('_' * 8, style: textStyle);

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(flex: 0.16),
          1: FlexColumnWidth(),
        },
        children: [
          TableRow(
            children: [
              text,
              text,
            ],
          ),
          TableRow(
            children: [
              text,
              text,
            ],
          ),
          TableRow(
            children: [
              text,
              text,
            ],
          ),
          TableRow(
            children: [
              text,
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
