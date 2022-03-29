import 'package:flutter/material.dart';

class StoryTilePadding extends StatelessWidget {
  const StoryTilePadding({Key? key, required this.child}) : super(key: key);

  final Widget child;
  static const _padding = 10.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _padding),
      child: child,
    );
  }
}
