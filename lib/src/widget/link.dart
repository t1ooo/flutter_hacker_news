import 'package:flutter/material.dart';

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
    return InkWell(
      onTap: () => launch(url),
      child: Tooltip(message: url, child: child),
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
