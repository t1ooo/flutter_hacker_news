import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news_prototype/src/widget/loading_placeholder.dart';

import 'user_activity_padding.dart';

class UserActivityPlaceholder extends StatelessWidget {
  const UserActivityPlaceholder({Key? key, this.depth = 0}) : super(key: key);

  final int depth;

  @override
  Widget build(BuildContext context) {
    return UserActivityPadding(child: LoadingPlaceholder());
  }
}
