// const commentMaxDepth = 5;
// const commentPadding = 10.0;
// const storyTilePadding = 10.0;

import 'package:flutter/widgets.dart';

EdgeInsets commentPadding([int depth = 0]) {
  const padding = 10.0;
  const commentMaxDepth = 2;
  final leftPadding = (depth <= commentMaxDepth ? depth : 0) * 30.0;

  return EdgeInsets.only(
    left: leftPadding,
    top: padding,
    bottom: padding,
  );
}
