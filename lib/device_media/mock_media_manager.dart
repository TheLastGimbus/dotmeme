import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';
import 'package:photo_manager/photo_manager.dart';

import 'media_manager.dart';

MediaManager getMockManager() {
  // TODO: Some way of getting test images
  return MockMediaManager();
}

class MediaPermissionException implements Exception {}

class MockMediaManager extends Mock implements MediaManager {
  bool _hasPermission = false;
  bool _ignorePermissionCheck = false;

  void _permissionCheck() {
    if (!_ignorePermissionCheck && !_hasPermission) {
      throw MediaPermissionException();
    }
  }

  /// in android WRITE_EXTERNAL_STORAGE  READ_EXTERNAL_STORAGE
  ///
  /// in ios request the photo permission
  ///
  /// Use [requestPermissionExtend] to instead;
  // @Deprecated("Use requestPermissionExtend")
  @override
  Future<bool> requestPermission() async =>
      (await requestPermissionExtend()).isAuth;

  /// Android: WRITE_EXTERNAL_STORAGE, READ_EXTERNAL_STORAGE, MEDIA_LOCATION
  ///
  /// iOS: NSPhotoLibraryUsageDescription of info.plist
  ///
  /// macOS of Release.entitlements:
  ///  - com.apple.security.assets.movies.read-write
  ///  - com.apple.security.assets.music.read-write
  ///
  /// Also see [PermissionState].
  @override
  Future<PermissionState> requestPermissionExtend({
    PermisstionRequestOption requestOption = const PermisstionRequestOption(),
  }) =>
      Future.delayed(Duration(seconds: _hasPermission ? 0 : 2), () {
        _hasPermission = true;
        return PermissionState.authorized;
      });

  @override
  Editor get editor => throw UnimplementedError("TODO");

  /// get gallery list
  ///
  /// 获取相册"文件夹" 列表
  ///
  /// [hasAll] contains all path, such as "Camera Roll" on ios or "Recent" on android.
  /// [hasAll] 包含所有项目的相册
  ///
  /// [onlyAll] If true, Return only one album with all resources.
  /// [onlyAll] 如果为真, 则只返回一个包含所有项目的相册
  @override
  Future<List<MockAssetPathEntity>> getAssetPathList({
    bool hasAll = true,
    bool onlyAll = false,
    RequestType type = RequestType.common,
    FilterOptionGroup? filterOption,
  }) {
    _permissionCheck();
    throw UnimplementedError("TODO");
  }

  /// Don't throw exceptions when accessing stuff without permission
  @override
  Future<void> setIgnorePermissionCheck(bool ignore) async =>
      _ignorePermissionCheck = ignore;

  /// Does nothing
  @override
  void openSetting();

  /// Does nothing
  @override
  Future releaseCache() => Future.delayed(const Duration(milliseconds: 50));

  @override
  void addChangeCallback(ValueChanged<MethodCall> callback) =>
      throw UnimplementedError("TODO");

  @override
  void removeChangeCallback(ValueChanged<MethodCall> callback) =>
      UnimplementedError("TODO");

  /// TODO: This stream
  @override
  bool get notifyingOfChange => throw UnimplementedError("TODO");

  @override
  Stream<bool> get notifyStream => throw UnimplementedError("TODO");

  @override
  void startChangeNotify() => throw UnimplementedError("TODO");

  @override
  void stopChangeNotify() => throw UnimplementedError("TODO");

  @override
  Future<MockAssetPathEntity?> fetchPathProperties({
    required AssetPathEntity entity,
    required FilterOptionGroup filterOptionGroup,
  }) =>
      throw UnimplementedError("TODO");

  /// Does nothing
  @override
  Future<void> forceOldApi();

  /// Static "30" version
  @override
  Future<String> systemVersion() async => "30";

  /// Does nothing
  @override
  Future<void> clearFileCache();

  /// Does nothing
  @override
  Future<bool> setCacheAtOriginBytes(bool cache) async => cache;

  @override
  Future<MockAssetEntity?> refreshAssetProperties(String id) =>
      throw UnimplementedError("TODO");

  // ############### MY OWN METHODS ################
  // They replace static methods of AssetEntities

  @override
  Future<MockAssetEntity?> assetEntityFromId(String id) =>
      MockAssetEntity.fromId(id);

  @override
  Future<AssetPathEntity> assetPathEntityFromId(
    String id, {
    FilterOptionGroup? filterOption,
    RequestType type = RequestType.common,
    int albumType = 1,
  }) =>
      MockAssetPathEntity.fromId(
        id,
        filterOption: filterOption,
        type: type,
        albumType: albumType,
      );
}

// BIG TODO: Some magic way to get media while testing
// We possibly need to emulate whole system
// This could be in a form of some json file containing data
// (Like id, isFavourite, etc)
// And .jpg files saved in test/ dir
// (or preferably, git submodule to not make repo heavy)

class MockAssetPathEntity extends Mock implements AssetPathEntity {
  static Future<MockAssetPathEntity> fromId(
    String id, {
    FilterOptionGroup? filterOption,
    RequestType type = RequestType.common,
    int albumType = 1,
  }) =>
      throw UnimplementedError("TODO");
}

class MockAssetEntity extends Mock implements AssetEntity {
  static Future<MockAssetEntity?> fromId(String id) =>
      throw UnimplementedError("TODO");
}
