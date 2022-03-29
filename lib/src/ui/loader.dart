import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class Loader<T> extends StatelessWidget {
  Loader({
    Key? key,
    required this.load,
    required this.builder,
  }) : super(key: key);

  final Future<T> Function() load;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    // return InitBuilder(
    //   initState: load,
    //   builder: builder,
    // );

    // return FutureBuilder(
    //   future: load,
    //   builder: (BuildContext context, _ ) => builder(context),
    // );

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      load();
    });
    return builder(context);
  }
}
