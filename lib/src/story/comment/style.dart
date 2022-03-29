// const commentMaxDepth = 5;
// const commentPadding = 10.0;
// const storyTilePadding = 10.0;

import 'dart:math';

import 'package:flutter/widgets.dart';

EdgeInsets commentPadding([int depth = 0]) {
  const _padding = 10.0;
  const _commentMaxDepth = 5;

  final leftPadding = min(depth, _commentMaxDepth) * 30.0;
  return EdgeInsets.only(left: leftPadding, top: _padding, bottom: _padding);
}
