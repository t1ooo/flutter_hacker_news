import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import '../style/style.dart';
import 'user_activities_loader.dart';

class UserActivitiesScreen extends StatelessWidget {
  const UserActivitiesScreen({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Activity'),
      ),
      body: Padding(
        padding: pagePadding,
        child: MultiProvider(
          providers: [
            userProvider(),
            itemProvider(),
            commentProvider(),
          ],
          child: UserActivitiesLoader(name: name),
        ),
      ),
    );
  }
}
