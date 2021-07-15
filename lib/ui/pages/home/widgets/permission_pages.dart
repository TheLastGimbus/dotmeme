import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WaitingForPermissionPage extends StatelessWidget {
  const WaitingForPermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("dotmeme - waiting for memes \u{231A}")),
      body: const Center(
        child: Text(
          "Please give dotmeme permission to access your memes \u{1F97A}",
        ),
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
    final th = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("dotmeme - without memes \u{1F622}")),
      body: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "dotmeme doesn't have permission to access your photos \u{1F615} ",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const Text(
              "Without photos, there is no memes, and without memes... "
              "there is no memes \u{1F636}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRequestPermissionPressed,
              child: const Text("Give permission \u{1F64F}"),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onOpenSettingsPressed,
              child: const Text("Go to app settings \u{1F527}"),
            ),
          ],
        ),
      ),
    );
  }
}
