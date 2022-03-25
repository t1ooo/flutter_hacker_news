import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';

import '../hacker_news_notifier.dart';
import '../item.dart';
import 'html.dart';
import 'user.dart';
import 'load_indicator.dart';

const commentMaxDepth = 5;

class ChangeNotifierBuilder<T extends ChangeNotifier> extends StatelessWidget {
  ChangeNotifierBuilder({
    Key? key,
    required this.notifier,
    required this.builder,
  }) : super(key: key);

  final T notifier;
  final Widget Function(BuildContext, T) builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: notifier,
      builder: (BuildContext context, _) {
        return builder(context, notifier);
      },
    );
  }
}
