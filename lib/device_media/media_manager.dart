import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

export 'package:photo_manager/src/type.dart';

class MediaManager {
  /// in android WRITE_EXTERNAL_STORAGE  READ_EXTERNAL_STORAGE
  ///
  /// in ios request the photo permission
  ///
  /// Use [requestPermissionExtend] to instead;
  // @Deprecated("Use requestPermissionExtend")
  Future<bool> requestPermission() => PhotoManager.requestPermission();

  /// Android: WRITE_EXTERNAL_STORAGE, READ_EXTERNAL_STORAGE, MEDIA_LOCATION
  ///
  /// iOS: NSPhotoLibraryUsageDescription of info.plist
  ///
  /// macOS of Release.entitlements:
  ///  - com.apple.security.assets.movies.read-write
  ///  - com.apple.security.assets.music.read-write
  ///
  /// Also see [PermissionState].
  Future<PermissionState> requestPermissionExtend({
    PermisstionRequestOption requestOption = const PermisstionRequestOption(),
  }) =>
      PhotoManager.requestPermissionExtend(requestOption: requestOption);

  /// Prompts the user to update their limited library selection.
  ///
  /// This method just support iOS(14.0+).
  ///
  /// See document of [Apple doc][].
  ///
  /// [Apple doc]: https://developer.apple.com/documentation/photokit/phphotolibrary/3616113-presentlimitedlibrarypickerfromv/
  Future<void> presentLimited() => PhotoManager.presentLimited();

  Editor get editor => PhotoManager.editor;

  /// get gallery list
  ///
  /// 获取相册"文件夹" 列表
  ///
  /// [hasAll] contains all path, such as "Camera Roll" on ios or "Recent" on android.
  /// [hasAll] 包含所有项目的相册
  ///
  /// [onlyAll] If true, Return only one album with all resources.
  /// [onlyAll] 如果为真, 则只返回一个包含所有项目的相册
  Future<List<AssetPathEntity>> getAssetPathList({
    bool hasAll = true,
    bool onlyAll = false,
    RequestType type = RequestType.common,
    FilterOptionGroup? filterOption,
  }) =>
      PhotoManager.getAssetPathList(
          hasAll: hasAll,
          onlyAll: onlyAll,
          type: type,
          filterOption: filterOption);

  /// Use [getAssetPathList] replaced.
  @Deprecated("Use getAssetPathList replaced.")
  Future<List<AssetPathEntity>> getImageAsset() => PhotoManager.getImageAsset();

  /// Use [getAssetPathList] replaced.
  @Deprecated("Use getAssetPathList replaced.")
  Future<List<AssetPathEntity>> getVideoAsset() => PhotoManager.getVideoAsset();

  Future<void> setLog(bool isLog) => PhotoManager.setLog(isLog);

  /// Ignore permission checks at runtime, you can use third-party permission plugins to request permission. Default is false.
  ///
  /// For Android, a typical usage scenario may be to use it in Service, because Activity cannot be used in Service to detect runtime permissions, but it should be noted that deleting resources above android10 require activity to accept the result, so the delete system does not apply to this Attributes.
  ///
  /// For iOS, this feature is only added, please explore the specific application scenarios by yourself
  Future<void> setIgnorePermissionCheck(bool ignore) =>
      PhotoManager.setIgnorePermissionCheck(ignore);

  /// get video asset
  /// open setting page
  void openSetting() => PhotoManager.openSetting();

  /// Release all native(ios/android) caches, normally no calls are required.
  ///
  /// The main purpose is to help clean up problems where memory usage may be too large when there are too many pictures.
  ///
  /// Warning:
  ///
  ///   Once this method is invoked, unless you call the [getAssetPathList] method again, all the [AssetEntity] and [AssetPathEntity] methods/fields you have acquired will fail or produce unexpected results.
  ///
  ///   This method should only be invoked when you are sure you really want to do so.
  ///
  ///   This method is asynchronous, and calling [getAssetPathList] before the Future of this method returns causes an error.
  ///
  ///
  /// 释放资源的方法,一般情况下不需要调用
  ///
  /// 主要目的是帮助清理当图片过多时,内存占用可能过大的问题
  ///
  /// 警告:
  ///
  /// 一旦调用这个方法,除非你重新调用  [getAssetPathList] 方法,否则你已经获取的所有[AssetEntity]/[AssetPathEntity]的所有字段都将失效或产生无法预期的效果
  ///
  /// 这个方法应当只在你确信你真的需要这么做的时候再调用
  ///
  /// 这个方法是异步的,在本方法的Future返回前调用getAssetPathList 可能会产生错误
  Future releaseCache() => PhotoManager.releaseCache();

  /// see [_NotifyManager]
  void addChangeCallback(ValueChanged<MethodCall> callback) =>
      PhotoManager.addChangeCallback(callback);

  /// see [_NotifyManager]
  void removeChangeCallback(ValueChanged<MethodCall> callback) =>
      PhotoManager.removeChangeCallback(callback);

  /// Whether to monitor the change of photo album.
  bool get notifyingOfChange => PhotoManager.notifyingOfChange;

  /// See [_NotifyManager.notifyStream]
  Stream<bool> get notifyStream => PhotoManager.notifyStream;

  /// see [_NotifyManager]
  void startChangeNotify() => PhotoManager.startChangeNotify();

  /// see [_NotifyManager]
  void stopChangeNotify() => PhotoManager.stopChangeNotify();

  /// [AssetPathEntity.refreshPathProperties]
  Future<AssetPathEntity?> fetchPathProperties({
    required AssetPathEntity entity,
    required FilterOptionGroup filterOptionGroup,
  }) =>
      PhotoManager.fetchPathProperties(
          entity: entity, filterOptionGroup: filterOptionGroup);

  /// Only valid for Android 29. The API of API 28 must be used with the property of `requestLegacyExternalStorage`.
  Future<void> forceOldApi() => PhotoManager.forceOldApi();

  /// Get system version
  Future<String> systemVersion() => PhotoManager.systemVersion();

  /// Clear all file cache.
  Future<void> clearFileCache() => PhotoManager.clearFileCache();

  /// When set to true, origin bytes in Android Q will be cached as a file. When use again, the file will be read.
  Future<bool> setCacheAtOriginBytes(bool cache) =>
      PhotoManager.setCacheAtOriginBytes(cache);

  /// Refresh the property of asset.
  Future<AssetEntity?> refreshAssetProperties(String id) =>
      PhotoManager.refreshAssetProperties(id);

  // ############### MY OWN METHODS ################
  // They replace static methods of AssetEntities

  Future<AssetEntity?> assetEntityFromId(String id) => AssetEntity.fromId(id);

  Future<AssetPathEntity?> assetPathEntityFromId(
    String id, {
    FilterOptionGroup? filterOption,
    RequestType type = RequestType.common,
    int albumType = 1,
  }) =>
      AssetPathEntity.fromId(
        id,
        filterOption: filterOption,
        type: type,
        albumType: albumType,
      );
}
