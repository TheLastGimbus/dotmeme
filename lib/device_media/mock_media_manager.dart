/// # What the hell is this and how it works?
///
/// Here, I managed to emulate whole MediaManager on normal desktop system
/// (should work on both Linux, MacOS and Windoza)
///
/// Detailed info about test media structure is in [test repo README.md](https://github.com/TheLastGimbus/__dotmeme_test_media__)
///
/// This class reads info from `index.json` and emulates folders on real device
///
/// You can download and set up whole `_test_media/` folder by running
/// `setup-test-media.sh` script
///
/// Notes:
/// - when doing stuff with filesystem, use "someStuffSync()" methods instead of
///   async ones. There's something weird with flutter test :/
/// - idk if I shouldn't also move this (mock_manager) to `test/` folder
///
import 'dart:convert' as convert;
import 'dart:io' as io;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:image/image.dart' as imglib;
import 'package:image_size_getter/file_input.dart' as isgfi;
import 'package:image_size_getter/image_size_getter.dart' as imgsizeget;
import 'package:logger/logger.dart';
import 'package:mime/mime.dart' as mime;
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:photo_manager/photo_manager.dart';

import 'media_manager.dart';

class MockMediaManager extends Mock implements MediaManager {
  // All implementations here are very similar (ugly and bad) as in original
  // photo_manager

  bool _hasPermission = false;
  bool _ignorePermissionCheck = false;
  final io.Directory _mediaFolder;
  late Map _index;

  /// Never give permission. Useful for testing
  bool testNoPermission = false;

  MockMediaManager({io.Directory? mediaFolder})
      : _mediaFolder = mediaFolder ?? io.Directory('test/_test_media/') {
    assert(_mediaFolder.existsSync());
    final iFile = io.File(path.join(_mediaFolder.path, 'index.json'));
    assert(iFile.existsSync());
    _index = convert.jsonDecode(iFile.readAsStringSync());
    assert(_index.containsKey("paths"));
  }

  // ############# Test env filesystem helpers #############
  /// Returns Map (json object from index.json) of asset,
  /// with additional [filepath] field
  Map? _findAsset(String id) {
    for (final pathId in (_index["paths"] as Map).keys) {
      for (final assetId in (_index["paths"][pathId]["assets"] as Map).keys) {
        if (assetId == id) {
          final ass = Map.from(_index["paths"][pathId]["assets"][assetId]);
          ass["filepath"] =
              path.join(_index["paths"][pathId]["path"], ass["filename"]);
          return ass;
        }
      }
    }
  }

  Future<void> _permissionCheck() async {
    if (!_ignorePermissionCheck && !_hasPermission) {
      if ((await requestPermissionExtend()) != PermissionState.authorized) {
        throw PlatformException(
            code: 'Request for permission failed.',
            message: 'User denied permission.');
      }
    }
  }

  /// See [requestPermissionExtend]
  @Deprecated("Use requestPermissionExtend")
  @override
  Future<bool> requestPermission() async =>
      (await requestPermissionExtend()).isAuth;

  /// Waits two seconds the first time and returns true, then returns instantly
  /// TODO: Emulate no/random permission
  @override
  Future<PermissionState> requestPermissionExtend({
    PermisstionRequestOption requestOption = const PermisstionRequestOption(),
  }) =>
      Future.delayed(Duration(seconds: _hasPermission ? 0 : 2), () {
        _hasPermission = !testNoPermission;
        return _hasPermission
            ? PermissionState.authorized
            : PermissionState.denied;
      });

  @override
  Editor get editor => throw UnimplementedError("TODO");

  @override
  Future<List<MockAssetPathEntity>> getAssetPathList({
    bool hasAll = true,
    bool onlyAll = false,
    RequestType type = RequestType.common,
    FilterOptionGroup? filterOption,
  }) async {
    await _permissionCheck();
    if (hasAll || onlyAll) {
      throw UnimplementedError("'All' folder is not implemented yet");
    }
    if (type != RequestType.common || filterOption != null) {
      GetIt.I<Logger>().w("RequestType and Filter option are not fully "
          "implemented in Mock yet!");
    }
    return [
      for (String id in (_index["paths"] as Map).keys)
        (await assetPathEntityFromId(id, filterOption: filterOption))!
    ];
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

  // Idk if I will every implement this, it sucks anyway :/
  @override
  void addChangeCallback(ValueChanged<MethodCall> callback) =>
      throw UnimplementedError("TODO");

  @override
  void removeChangeCallback(ValueChanged<MethodCall> callback) =>
      UnimplementedError("TODO");

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
  }) async {
    await _permissionCheck();
    entity = entity as MockAssetPathEntity;
    final assPath = _index["paths"][entity.id] as Map?;
    if (assPath == null) return null;
    final assetIds = (assPath["assets"] as Map).keys;
    final mock = MockAssetPathEntity()
      .._assets = [for (final id in assetIds) (await assetEntityFromId(id))!]
      ..id = entity.id
      ..name = path.basename(assPath["path"])
      ..assetCount = assetIds.length
      .._type = entity.type
      ..filterOption = filterOptionGroup
      ..albumType = entity.albumType;
    if (filterOptionGroup.containsPathModified) {
      mock.lastModified = io.Directory(
              path.join(_mediaFolder.path, assPath["path"]))
          .statSync()
          .modified
          // Note: Idk if PhotoManager returns UTC (probably not) and whether we
          // should convert it in MediaManager (to have it clean in the db)
          .toUtc();
    }
    return mock;
  }

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

  // If all of this actual file parsing will ever be too much, feel free
  // to replace this with hand-written info in index.json
  @override
  Future<MockAssetEntity?> refreshAssetProperties(String id) async {
    await _permissionCheck();
    final ass = _findAsset(id);
    if (ass == null) return null;
    final file = io.File(path.join(_mediaFolder.path, ass["filepath"]));
    assert(file.existsSync());
    final stat = file.statSync();
    final size = imgsizeget.ImageSizeGetter.getSize(isgfi.FileInput(file));
    final mimeType = mime.lookupMimeType(file.path);
    final _type = mimeType?.split('/')[0];
    var type = AssetType.other;
    switch (_type) {
      case 'image':
        type = AssetType.image;
        break;
      case 'video':
        type = AssetType.video;
        break;
      case 'audio':
        type = AssetType.audio;
        break;
    }
    return MockAssetEntity(
      id: id,
      typeInt: type.index,
      width: size.width,
      height: size.height,
      duration: ass["duration"],
      orientation: 0,
      isFavorite: false,
      title: ass["filename"],
      // Note: Idk if PhotoManager returns UTC (probably not) and whether we
      // should convert it in MediaManager (to have it clean in the db)
      createDtSecond: stat.modified.toUtc().millisecondsSinceEpoch ~/ 1000,
      modifiedDateSecond: stat.modified.toUtc().millisecondsSinceEpoch ~/ 1000,
      relativePath: file.path,
      mimeType: mimeType,
      file: file,
    );
  }

  // ############### MY OWN METHODS ################
  // They replace static methods of AssetEntities

  @override
  Future<MockAssetEntity?> assetEntityFromId(String id) =>
      _permissionCheck().then((value) => refreshAssetProperties(id));

  @override
  Future<MockAssetPathEntity?> assetPathEntityFromId(
    String id, {
    FilterOptionGroup? filterOption,
    RequestType type = RequestType.common,
    int albumType = 1,
  }) async {
    await _permissionCheck();
    final en = MockAssetPathEntity()
      ..id = id
      ..filterOption = filterOption ?? FilterOptionGroup()
      ..typeInt = type.index
      ..albumType = albumType;
    return fetchPathProperties(
      entity: en,
      filterOptionGroup: filterOption ?? FilterOptionGroup(),
    );
  }
}

class MockAssetPathEntity extends Mock implements AssetPathEntity {
  /// This is only in mock
  late List<MockAssetEntity> _assets;

  @override
  late final String id;

  @override
  late String name;

  // Idk if I shouldn't do it as _assets.length
  // But let's leave it as dumb as it is in plugin D:
  @override
  late int assetCount;

  @override
  late int albumType;

  late RequestType _type;

  @override
  late FilterOptionGroup filterOption;

  @override
  DateTime? lastModified;

  @override
  RequestType get type => _type;

  @override
  set type(RequestType type) {
    _type = type;
    typeInt = type.index;
  }

  @override
  int get typeInt => type.value;

  @override
  set typeInt(int typeInt) {
    _type = RequestType(typeInt);
  }

  @override
  bool isAll = false;

  @override
  Future<List<AssetEntity>> getAssetListPaged(int page, int pageSize) =>
      getAssetListRange(start: pageSize * page, end: (pageSize * (page + 1)));

  @override
  Future<List<AssetEntity>> getAssetListRange({
    required int start,
    required int end,
  }) async {
    assert(albumType == 1, "Only album type can get asset.");
    assert(start >= 0, "The start must better than 0.");
    assert(end > start, "The end must better than start.");
    // Emulate how slow plugin is D:
    return Future.delayed(
      Duration(milliseconds: (end - start) * 1),
      () => _assets.sublist(start, end),
    );
  }

  @override
  Future<List<AssetEntity>> get assetList => getAssetListPaged(0, assetCount);

  @override
  bool operator ==(other) {
    if (other is! AssetPathEntity) {
      return false;
    }
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "AssetPathEntity{ name: $name, id:$id, length = $assetCount }";
  }
}

class MockAssetEntity extends Mock implements AssetEntity {
  MockAssetEntity(
      {required this.id,
      required this.typeInt,
      required this.width,
      required this.height,
      this.duration = 0,
      this.orientation = 0,
      this.isFavorite = false,
      this.title,
      this.createDtSecond,
      this.modifiedDateSecond,
      this.relativePath,
      this.mimeType,
      required file})
      : _file = file;

  @override
  String id;

  @override
  String? title;

  @override
  AssetType get type {
    switch (typeInt) {
      case 1:
        return AssetType.image;
      case 2:
        return AssetType.video;
      case 3:
        return AssetType.audio;
      default:
        return AssetType.other;
    }
  }

  @override
  int typeInt;

  @override
  int duration;

  @override
  int width;

  @override
  int height;

  final io.File _file;

  @override
  Future<io.File?> get file =>
      Future.delayed(const Duration(milliseconds: 5), () => _file);

  /// Same as [file]
  @override
  Future<io.File?> get originFile => file;

  @override
  Future<Uint8List?> get originBytes => file.then((f) => f!.readAsBytesSync());

  // ignore: unused_element
  Uint8List? _getResized(Uint8List image, int w, int h) {
    final img = imglib.decodeImage(image);
    if (img == null) return null;
    return imglib.copyResize(img, width: w, height: h).getBytes();
  }

  @override
  Future<Uint8List?> get thumbData => thumbDataWithSize(150, 150);

  @override
  Future<Uint8List?> thumbDataWithSize(
    int width,
    int height, {
    ThumbFormat format = ThumbFormat.jpeg,
    int quality = 100,
    PMProgressHandler? progressHandler,
  }) async {
    assert(width > 0 && height > 0, "The width and height must better 0.");
    assert(quality > 0 && quality <= 100, "The quality must between 0 and 100");
    if (type != AssetType.image) return null;
    final bytes = _file.readAsBytesSync();
    // TODO:  Sorry but this wasn't working D: images couldn't load :(
    // final res = _getResized(bytes, width, height);
    return bytes;
  }

  @override
  Duration get videoDuration => Duration(seconds: duration);

  @override
  Size get size => Size(width.toDouble(), height.toDouble());

  @override
  int? createDtSecond;

  @override
  DateTime get createDateTime => DateTime.fromMillisecondsSinceEpoch(
      (createDtSecond ?? DateTime.now().millisecondsSinceEpoch) * 1000);

  @override
  int? modifiedDateSecond;

  @override
  DateTime get modifiedDateTime => DateTime.fromMillisecondsSinceEpoch(
      (modifiedDateSecond ?? DateTime.now().millisecondsSinceEpoch) * 1000);

  @override
  Future<bool> get exists async => true;

  @override
  Future<String?> getMediaUrl() async => _file.absolute.path;

  @override
  int orientation;

  @override
  bool isFavorite;

  @override
  String? relativePath;

  @override
  String? mimeType;

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  bool operator ==(other) {
    if (other is! AssetEntity) {
      return false;
    }
    return id == other.id;
  }

  @override
  String toString() {
    return "AssetEntity{ id:$id , type: $type}";
  }
}
