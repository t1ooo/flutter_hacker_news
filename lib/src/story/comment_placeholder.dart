import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'const.dart';

class CommentPlaceholder extends StatelessWidget {
  const CommentPlaceholder({Key? key, this.depth=0}) : super(key: key);

  final int depth;

  @override
  Widget build(BuildContext context) {
    final leftPadding = min(depth, commentMaxDepth) * 30.0;
    // TODO: move to shimmer.dart
    final textStyle = TextStyle(
      color: Colors.white,
      backgroundColor: Colors.white,
    );

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.only(
          left: leftPadding,
          top: commentPadding,
          bottom: commentPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('_' * 40, style: textStyle),  // TODO: move to shimmer.dart
            Text('_' * 250, style: textStyle),
          ],
        ),
      ),
    );
  }
}
