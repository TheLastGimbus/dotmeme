import 'package:dotmeme/preferences.dart';
import 'package:dotmeme/providers/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppearanceSettingsPage extends StatefulWidget {
  @override
  _AppearanceSettingsPageState createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  @override
  Widget build(BuildContext context) {
    var spProvider = Provider.of<SharedPreferencesProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(title: Text('App theme:')),
            RadioListTile(
              title: Text('Follow system'),
              value: ThemeModePreference.SYSTEM,
              groupValue: spProvider.themePref,
              onChanged: (v) => spProvider.themePref = v,
            ),
            RadioListTile(
              title: Text('Light'),
              value: ThemeModePreference.LIGHT,
              groupValue: spProvider.themePref,
              onChanged: (v) => spProvider.themePref = v,
            ),
            RadioListTile(
              title: Text('Dark'),
              value: ThemeModePreference.DARK,
              groupValue: spProvider.themePref,
              onChanged: (v) => spProvider.themePref = v,
            ),
          ],
        ),
      ),
    );
  }
}
