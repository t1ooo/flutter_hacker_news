import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import '../hacker_news_api.dart';
import '../hacker_news_notifier.dart';
import '../item.dart';
import '../style/style.dart';
import '../user.dart';
import 'item_list.dart';

class TopstoriesScreen extends StatelessWidget {
  const TopstoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TopstoriesScreen'),
      ),
      body: Padding(padding: pagePadding, child: ItemList()),
    );
  }
}
