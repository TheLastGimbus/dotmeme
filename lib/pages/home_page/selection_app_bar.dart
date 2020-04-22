import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget selectionAppBar(BuildContext context) {
  var homeProvider = Provider.of<HomePageProvider>(context);
  return AppBar(
    title: Text('Selected ${homeProvider.selectControl.selection.amount}'),
    leading: IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        homeProvider.selectControl.clear();
      },
    ),
    actions: <Widget>[
      IconButton(icon: Icon(Icons.share)),
      IconButton(icon: Icon(Icons.delete)),
      IconButton(icon: Icon(Icons.more_vert)),
    ],
    backgroundColor: Colors.black38,
    brightness: Brightness.dark,
  );
}
