import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'const.dart';

class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({Key? key, this.depth = 0}) : super(key: key);

  final int depth;

  @override
  Widget build(BuildContext context) {
    final leftPadding = min(depth, commentMaxDepth) * 30.0; // TODO: move to comment padding
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
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          color: Colors.white,
        ),
      ),
    );
  }
}
