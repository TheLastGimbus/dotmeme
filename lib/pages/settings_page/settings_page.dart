import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Folders settings'),
            )
          ],
        ),
      ),
    );
  }
}
