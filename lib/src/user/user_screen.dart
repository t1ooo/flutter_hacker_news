import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import '../style/style.dart';

import 'user_loader.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
      ),
      body: Padding(
        padding: pagePadding,
        child: MultiProvider(
          providers: [
            userProvider(),
          ],
          child: UserLoader(name: name),
        ),
      ),
    );
  }
}
