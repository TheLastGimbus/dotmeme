import 'package:dotmeme/background/periodic_cv_scan.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    //simpleTask will be emitted here.
    switch (task) {
      case PeriodicCvScan.TASK_NAME_OCR:
        await PeriodicCvScan.ocrScan();
        break;
    }
    return Future.value(true);
  });
}

class WorkManagerUtils {
  static initialize() {
    Workmanager.initialize(callbackDispatcher, isInDebugMode: true);
    Workmanager.registerPeriodicTask(
      "1",
      PeriodicCvScan.TASK_NAME_OCR,
      frequency: Duration(minutes: 15),
      tag: PeriodicCvScan.TAG,
      existingWorkPolicy: ExistingWorkPolicy.keep,
      constraints: Constraints(requiresBatteryNotLow: true),
    );
  }
}
