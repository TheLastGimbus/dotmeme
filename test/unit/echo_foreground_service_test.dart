import 'package:dotmeme/background/foreground_service/mock_foreground_service_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      "Test if EchoForegroundService managed by mock ForegroundServiceManager "
      "responds", () async {
    final fsm = MockForegroundServiceManager();
    expect(await fsm.startEchoService(), true);
    expect(
        fsm.receiveStream,
        emitsInOrder([
          "dupa12",
          "bla bla blabla",
          "CLOSE",
        ]));
    fsm.send("dupa12");
    fsm.send("bla bla blabla");
    fsm.send("CLOSE");
    // Sorry but expect(... throwsA) doesn't work :/
    try {
      fsm.send("this should not be here");
      throw "This should be already in catch D:";
      // ignore: empty_catches
    } on StateError catch (_) {}

    await fsm.dispose();
  });
}
