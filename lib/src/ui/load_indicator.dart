import 'package:flutter/material.dart';

class LoadIndicator extends StatelessWidget {
  LoadIndicator({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
  }
}
