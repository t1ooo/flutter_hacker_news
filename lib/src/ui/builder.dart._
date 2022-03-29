import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class InitBuilder extends StatefulWidget {
  InitBuilder({
    Key? key,
    required this.initState,
    required this.builder,
  }) : super(key: key);

  final void Function() initState;
  final WidgetBuilder builder;

  @override
  State<InitBuilder> createState() => _InitBuilderState();
}

class _InitBuilderState extends State<InitBuilder> {
  @override
  void initState() {
    widget.initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
