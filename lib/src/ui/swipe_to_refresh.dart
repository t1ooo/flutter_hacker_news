import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SwipeToRefresh extends StatelessWidget {
  const SwipeToRefresh({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: child,
      ),
    );
  }
}
