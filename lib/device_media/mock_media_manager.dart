import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:photo_manager/photo_manager.dart';

import 'media_manager.dart';
import 'mock_media_manager.mocks.dart';

@GenerateMocks([
  MediaManager,
  AssetPathEntity,
  AssetEntity,
])
MediaManager getMockManager() {
  final m = MockMediaManager();
  when(m.requestPermissionExtend()).thenAnswer((_) => Future.delayed(
      const Duration(seconds: 2), () => PermissionState.authorized));
  when(m.requestPermission()).thenAnswer(
      (real) => m.requestPermissionExtend().then((value) => value.isAuth));
  // TODO: Some way of getting test images
  return m;
}
