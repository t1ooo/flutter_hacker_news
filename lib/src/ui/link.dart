import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

// class WebLink extends StatelessWidget {
//   WebLink({
//     Key? key,
//     required this.child,
//     this.url,
//   }) : super(key: key);

//   final String? url;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: (url == null) ? null : () => launch(url!),
//       // child: child,
//       child: Tooltip(child: child, message: url),
//     );
//   }
// }

class WebLink extends StatelessWidget {
  WebLink({
    Key? key,
    required this.url,
    required this.child,
  }) : super(key: key);

  final String url;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launch(url),
      // child: child,
      child: Tooltip(child: child, message: url),
    );
  }
}

class MaterialAppLink extends StatelessWidget {
  MaterialAppLink({
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
    return InkWell(
      onTap: !active
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: routeBuilder),
              );
            },
      child: child,
    );
  }
}
