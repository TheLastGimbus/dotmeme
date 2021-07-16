import 'dart:isolate';

import 'package:flutter/material.dart';

import '../../../../background/foreground_service/foreground_service.dart'
    as foreground;

class ForegroundServicePage extends StatelessWidget {
  const ForegroundServicePage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const ForegroundServicePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foreground service debug")),
      body: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Current Isolate: ${Isolate.current.debugName} : "
              "${Isolate.current.hashCode}",
            ),
            ElevatedButton(
              onPressed: () => foreground.startService(),
              child: const Text("Start service"),
            ),
            ElevatedButton(
              onPressed: () => foreground.stopService(),
              child: const Text("Stop service"),
            ),
          ],
        ),
      ),
    );
  }
}
