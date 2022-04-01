import 'package:flutter/material.dart';

import '../../widget/loading_placeholder.dart';
import 'style.dart';

class CommentPlaceholder extends StatelessWidget {
  const CommentPlaceholder({Key? key, this.depth = 0}) : super(key: key);

  final int depth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: commentPadding(depth),
      child: LoadingPlaceholder(),
    );
  }
}
