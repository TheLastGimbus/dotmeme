import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // I don't know if this is the way we will route, probably not
  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const SettingsPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: const Center(
        child: Text("Settings will be here"),
      ),
    );
  }
}
