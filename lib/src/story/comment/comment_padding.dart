import 'dart:math';

import 'package:flutter/material.dart';

class CommentPadding extends StatelessWidget {
  const CommentPadding({
    Key? key,
    required this.child,
    this.depth = 0,
  }) : super(key: key);

  final int depth;
  final Widget child;
  static const _commentPadding = 10.0;
  static const _commentMaxDepth = 5;

  @override
  Widget build(BuildContext context) {
    final leftPadding = min(depth, _commentMaxDepth) * 30.0;
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        top: _commentPadding,
        bottom: _commentPadding,
      ),
      child: child,
    );
  }
}
