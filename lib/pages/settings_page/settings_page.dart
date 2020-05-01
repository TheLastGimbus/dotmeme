import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Folders settings'),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/settings_page/folders_settings_page');
              },
            )
          ],
        ),
      ),
    );
  }
}
