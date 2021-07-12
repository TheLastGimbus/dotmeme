import 'package:dotmeme/device_media/media_manager.dart';
import 'package:dotmeme/device_media/mock_media_manager.dart';
import 'package:dotmeme/di.dart' as di;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  testWidgets('Basic home test', (WidgetTester tester) async {
    // Initialize DI (database etc) with test data
    di.init(di.Environment.test);
    // TODO: Actual Home page test

    final mm = GetIt.I<MediaManager>() as MockMediaManager;
    await tester.runAsync(() async {
      await mm.requestPermissionExtend();
      final p = await mm.assetEntityFromId("437854092489234");
      print(p);
      for (final folder in await mm.getAssetPathList(hasAll: false)) {
        print(folder.name);
        for (final meme in await folder.assetList) {
          print(meme.title);
        }
      }
    });
  });
}
