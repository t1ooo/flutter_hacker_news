import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class WebLink extends StatelessWidget {
  const WebLink({
    Key? key,
    required this.url,
    required this.child,
  }) : super(key: key);

  final String url;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // return TextButton(
    //   onPressed: () => launch(url),
    //   child: Tooltip(child: child, message: url),
    // );
    return InkWell(
      onTap: () => launch(url),
      child: Tooltip(child: child, message: url),
    );
  }
}

class MaterialAppLink extends StatelessWidget {
  const MaterialAppLink({
    Key? key,
    required this.routeBuilder,
    required this.child,
    this.active = true,
  }) : super(key: key);

  final Widget Function(BuildContext) routeBuilder;
  final Widget child;
  final bool active;

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   onTap: !active
    //       ? null
    //       : () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(builder: routeBuilder),
    //           );
    //         },
    //   child: Chip(
    //     label: child,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(5)),
    //     ),
    //   ),
    // );

    // return TextButton(
    //   onPressed: !active
    //       ? null
    //       : () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(builder: routeBuilder),
    //           );
    //         },
    //   child: child,
    // );

    return InkWell(
      onTap: active
          ? () {
              Navigator.push(context, MaterialPageRoute(builder: routeBuilder));
            }
          : null,
      child: child,
    );
  }
}
