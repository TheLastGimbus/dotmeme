import 'package:flutter/material.dart';

Widget selectionAppBar(){
  return AppBar(
    title: Text('Selected ${0}'), // TODO
    leading: IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        // TODO: Discard selection
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