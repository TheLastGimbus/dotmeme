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
              title: Text('Apperance'),
              subtitle: Text('Overall look of app'),
              onTap: () {
                Navigator.of(context).pushNamed(
                    '/settings_page/appearance_settings_page');
              },
            ),
            ListTile(
              title: Text('Folders'),
              subtitle: Text('Which folders contain memes'),
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
