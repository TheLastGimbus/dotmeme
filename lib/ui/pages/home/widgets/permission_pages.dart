

import 'package:flutter/material.dart';

class WaitingForPermissionPage extends StatelessWidget {
  const WaitingForPermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Plis give"),
      ),
    );
  }
}


class NoPermissionPage extends StatelessWidget {
  final VoidCallback onRequestPermissionPressed;
  final VoidCallback onOpenSettingsPressed;

  const NoPermissionPage({
    Key? key,
    required this.onRequestPermissionPressed,
    required this.onOpenSettingsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("App doesn't have permission for photos :("),
            TextButton(
              onPressed: onRequestPermissionPressed,
              child: const Text("Give permission"),
            ),
            TextButton(
              onPressed: onOpenSettingsPressed,
              child: const Text("Go to settings"),
            ),
          ],
        ),
      ),
    );
  }
}