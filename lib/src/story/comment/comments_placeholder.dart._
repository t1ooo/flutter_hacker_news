import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'comment_placeholder.dart';

class CommentsPlaceholder extends StatelessWidget {
  const CommentsPlaceholder({Key? key, this.limit = 20}) : super(key: key);

  final int limit;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      for (int i = 0; i < limit; i++) CommentPlaceholder(),
    ]);
  }
}
