import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../../background/foreground_service/foreground_service.dart'
    as foreground;

class ForegroundServicePage extends StatelessWidget {
  const ForegroundServicePage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const ForegroundServicePage());

  @override
  Widget build(BuildContext context) {
    final fsm = GetIt.I<foreground.ForegroundServiceManager>();
    final log = GetIt.I<Logger>();
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
              onPressed: () async {
                final res = await fsm.startService();
                log.i("Started service: $res");
              },
              child: const Text("Start service"),
            ),
            ElevatedButton(
              onPressed: () => fsm.stopService(),
              child: const Text("Stop service"),
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: "Type here to send to service"),
              onSubmitted: (text) {
                fsm.send(text);
              },
              textInputAction: TextInputAction.send,
            ),
            const SizedBox(height: 16),
            const Text("Data from service:"),
            StreamBuilder(
              stream: fsm.receiveStream,
              builder: (context, snap) {
                switch (snap.connectionState) {
                  case ConnectionState.active:
                    return Text(snap.data.toString());
                  case ConnectionState.done:
                    return const Text("Stream is done");
                  case ConnectionState.none:
                    return const Text("Stream is none");
                  case ConnectionState.waiting:
                    return const Text("Stream is waiting");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
