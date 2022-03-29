import 'package:flutter/material.dart';

import 'user_activity/user_activity_loader.dart';

class UserActivities extends StatelessWidget {
  const UserActivities({Key? key, required this.submitted}) : super(key: key);

  final List<int> submitted;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: submitted.length,
      itemBuilder: (_, int i) {
        final id = submitted[i];
        return UserActivityLoader(id: id);
      },
    );
  }
}
