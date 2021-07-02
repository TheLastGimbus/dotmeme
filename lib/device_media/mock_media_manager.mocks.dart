// Mocks generated by Mockito 5.0.10 from annotations
// in dotmeme/device_media/mock_media_manager.dart.
// Do not manually edit this file.

import 'dart:async' as _i7;
import 'dart:io' as _i10;
import 'dart:typed_data' as _i11;
import 'dart:ui' as _i5;

import 'package:dotmeme/device_media/media_manager.dart' as _i6;
import 'package:flutter/src/foundation/basic_types.dart' as _i8;
import 'package:flutter/src/services/message_codec.dart' as _i9;
import 'package:mockito/mockito.dart' as _i1;
import 'package:photo_manager/photo_manager.dart' as _i2;
import 'package:photo_manager/src/filter/filter_options.dart' as _i3;
import 'package:photo_manager/src/thumb_option.dart' as _i12;
import 'package:photo_manager/src/type.dart' as _i4;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeEditor extends _i1.Fake implements _i2.Editor {}

class _FakeFilterOptionGroup extends _i1.Fake implements _i3.FilterOptionGroup {
  @override
  String toString() => super.toString();
}

class _FakeRequestType extends _i1.Fake implements _i4.RequestType {
  @override
  String toString() => super.toString();
}

class _FakeDuration extends _i1.Fake implements Duration {
  @override
  String toString() => super.toString();
}

class _FakeSize extends _i1.Fake implements _i5.Size {
  @override
  String toString() => super.toString();
}

class _FakeDateTime extends _i1.Fake implements DateTime {
  @override
  String toString() => super.toString();
}

class _FakeLatLng extends _i1.Fake implements _i2.LatLng {}

/// A class which mocks [MediaManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockMediaManager extends _i1.Mock implements _i6.MediaManager {
  MockMediaManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Editor get editor => (super.noSuchMethod(Invocation.getter(#editor),
      returnValue: _FakeEditor()) as _i2.Editor);
  @override
  bool get notifyingOfChange =>
      (super.noSuchMethod(Invocation.getter(#notifyingOfChange),
          returnValue: false) as bool);
  @override
  set notifyingOfChange(bool? value) =>
      super.noSuchMethod(Invocation.setter(#notifyingOfChange, value),
          returnValueForMissingStub: null);
  @override
  _i7.Stream<bool> get notifyStream =>
      (super.noSuchMethod(Invocation.getter(#notifyStream),
          returnValue: Stream<bool>.empty()) as _i7.Stream<bool>);
  @override
  _i7.Future<bool> requestPermission() =>
      (super.noSuchMethod(Invocation.method(#requestPermission, []),
          returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  _i7.Future<_i4.PermissionState> requestPermissionExtend(
          {_i4.PermisstionRequestOption? requestOption =
              const _i4.PermisstionRequestOption()}) =>
      (super.noSuchMethod(
          Invocation.method(
              #requestPermissionExtend, [], {#requestOption: requestOption}),
          returnValue: Future<_i4.PermissionState>.value(
              _i4.PermissionState.notDetermined)) as _i7
          .Future<_i4.PermissionState>);
  @override
  _i7.Future<void> presentLimited() =>
      (super.noSuchMethod(Invocation.method(#presentLimited, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i7.Future<void>);
  @override
  _i7.Future<List<_i2.AssetPathEntity>> getAssetPathList(
          {bool? hasAll = true,
          bool? onlyAll = false,
          _i4.RequestType? type = _i4.RequestType.common,
          _i3.FilterOptionGroup? filterOption}) =>
      (super.noSuchMethod(
              Invocation.method(#getAssetPathList, [], {
                #hasAll: hasAll,
                #onlyAll: onlyAll,
                #type: type,
                #filterOption: filterOption
              }),
              returnValue: Future<List<_i2.AssetPathEntity>>.value(
                  <_i2.AssetPathEntity>[]))
          as _i7.Future<List<_i2.AssetPathEntity>>);
  @override
  _i7.Future<List<_i2.AssetPathEntity>> getImageAsset() => (super.noSuchMethod(
          Invocation.method(#getImageAsset, []),
          returnValue:
              Future<List<_i2.AssetPathEntity>>.value(<_i2.AssetPathEntity>[]))
      as _i7.Future<List<_i2.AssetPathEntity>>);
  @override
  _i7.Future<List<_i2.AssetPathEntity>> getVideoAsset() => (super.noSuchMethod(
          Invocation.method(#getVideoAsset, []),
          returnValue:
              Future<List<_i2.AssetPathEntity>>.value(<_i2.AssetPathEntity>[]))
      as _i7.Future<List<_i2.AssetPathEntity>>);
  @override
  _i7.Future<void> setLog(bool? isLog) =>
      (super.noSuchMethod(Invocation.method(#setLog, [isLog]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> setIgnorePermissionCheck(bool? ignore) => (super
      .noSuchMethod(Invocation.method(#setIgnorePermissionCheck, [ignore]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i7.Future<void>);
  @override
  void openSetting() => super.noSuchMethod(Invocation.method(#openSetting, []),
      returnValueForMissingStub: null);
  @override
  _i7.Future<dynamic> releaseCache() =>
      (super.noSuchMethod(Invocation.method(#releaseCache, []),
          returnValue: Future<dynamic>.value()) as _i7.Future<dynamic>);
  @override
  void addChangeCallback(_i8.ValueChanged<_i9.MethodCall>? callback) =>
      super.noSuchMethod(Invocation.method(#addChangeCallback, [callback]),
          returnValueForMissingStub: null);
  @override
  void removeChangeCallback(_i8.ValueChanged<_i9.MethodCall>? callback) =>
      super.noSuchMethod(Invocation.method(#removeChangeCallback, [callback]),
          returnValueForMissingStub: null);
  @override
  void startChangeNotify() =>
      super.noSuchMethod(Invocation.method(#startChangeNotify, []),
          returnValueForMissingStub: null);
  @override
  void stopChangeNotify() =>
      super.noSuchMethod(Invocation.method(#stopChangeNotify, []),
          returnValueForMissingStub: null);
  @override
  _i7.Future<_i2.AssetPathEntity?> fetchPathProperties(
          {_i2.AssetPathEntity? entity,
          _i3.FilterOptionGroup? filterOptionGroup}) =>
      (super.noSuchMethod(
              Invocation.method(#fetchPathProperties, [],
                  {#entity: entity, #filterOptionGroup: filterOptionGroup}),
              returnValue: Future<_i2.AssetPathEntity?>.value())
          as _i7.Future<_i2.AssetPathEntity?>);
  @override
  _i7.Future<void> forceOldApi() =>
      (super.noSuchMethod(Invocation.method(#forceOldApi, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i7.Future<void>);
  @override
  _i7.Future<String> systemVersion() =>
      (super.noSuchMethod(Invocation.method(#systemVersion, []),
          returnValue: Future<String>.value('')) as _i7.Future<String>);
  @override
  _i7.Future<void> clearFileCache() =>
      (super.noSuchMethod(Invocation.method(#clearFileCache, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i7.Future<void>);
  @override
  _i7.Future<bool> setCacheAtOriginBytes(bool? cache) =>
      (super.noSuchMethod(Invocation.method(#setCacheAtOriginBytes, [cache]),
          returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  _i7.Future<_i2.AssetEntity?> refreshAssetProperties(String? id) =>
      (super.noSuchMethod(Invocation.method(#refreshAssetProperties, [id]),
              returnValue: Future<_i2.AssetEntity?>.value())
          as _i7.Future<_i2.AssetEntity?>);
}

/// A class which mocks [AssetPathEntity].
///
/// See the documentation for Mockito's code generation for more information.
class MockAssetPathEntity extends _i1.Mock implements _i2.AssetPathEntity {
  MockAssetPathEntity() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: '') as String);
  @override
  set id(String? _id) => super.noSuchMethod(Invocation.setter(#id, _id),
      returnValueForMissingStub: null);
  @override
  String get name =>
      (super.noSuchMethod(Invocation.getter(#name), returnValue: '') as String);
  @override
  set name(String? _name) => super.noSuchMethod(Invocation.setter(#name, _name),
      returnValueForMissingStub: null);
  @override
  int get assetCount =>
      (super.noSuchMethod(Invocation.getter(#assetCount), returnValue: 0)
          as int);
  @override
  set assetCount(int? _assetCount) =>
      super.noSuchMethod(Invocation.setter(#assetCount, _assetCount),
          returnValueForMissingStub: null);
  @override
  int get albumType =>
      (super.noSuchMethod(Invocation.getter(#albumType), returnValue: 0)
          as int);
  @override
  set albumType(int? _albumType) =>
      super.noSuchMethod(Invocation.setter(#albumType, _albumType),
          returnValueForMissingStub: null);
  @override
  _i3.FilterOptionGroup get filterOption =>
      (super.noSuchMethod(Invocation.getter(#filterOption),
          returnValue: _FakeFilterOptionGroup()) as _i3.FilterOptionGroup);
  @override
  set filterOption(_i3.FilterOptionGroup? _filterOption) =>
      super.noSuchMethod(Invocation.setter(#filterOption, _filterOption),
          returnValueForMissingStub: null);
  @override
  set lastModified(DateTime? _lastModified) =>
      super.noSuchMethod(Invocation.setter(#lastModified, _lastModified),
          returnValueForMissingStub: null);
  @override
  bool get isAll =>
      (super.noSuchMethod(Invocation.getter(#isAll), returnValue: false)
          as bool);
  @override
  set isAll(bool? _isAll) =>
      super.noSuchMethod(Invocation.setter(#isAll, _isAll),
          returnValueForMissingStub: null);
  @override
  _i4.RequestType get type => (super.noSuchMethod(Invocation.getter(#type),
      returnValue: _FakeRequestType()) as _i4.RequestType);
  @override
  set type(_i4.RequestType? type) =>
      super.noSuchMethod(Invocation.setter(#type, type),
          returnValueForMissingStub: null);
  @override
  int get typeInt =>
      (super.noSuchMethod(Invocation.getter(#typeInt), returnValue: 0) as int);
  @override
  set typeInt(int? typeInt) =>
      super.noSuchMethod(Invocation.setter(#typeInt, typeInt),
          returnValueForMissingStub: null);
  @override
  _i7.Future<List<_i2.AssetEntity>> get assetList => (super.noSuchMethod(
          Invocation.getter(#assetList),
          returnValue: Future<List<_i2.AssetEntity>>.value(<_i2.AssetEntity>[]))
      as _i7.Future<List<_i2.AssetEntity>>);
  @override
  _i7.Future<void> refreshPathProperties({bool? maxDateTimeToNow = true}) =>
      (super.noSuchMethod(
          Invocation.method(#refreshPathProperties, [],
              {#maxDateTimeToNow: maxDateTimeToNow}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i7.Future<void>);
  @override
  _i7.Future<List<_i2.AssetEntity>> getAssetListPaged(
          int? page, int? pageSize) =>
      (super.noSuchMethod(
              Invocation.method(#getAssetListPaged, [page, pageSize]),
              returnValue:
                  Future<List<_i2.AssetEntity>>.value(<_i2.AssetEntity>[]))
          as _i7.Future<List<_i2.AssetEntity>>);
  @override
  _i7.Future<List<_i2.AssetEntity>> getAssetListRange({int? start, int? end}) =>
      (super.noSuchMethod(
          Invocation.method(#getAssetListRange, [], {#start: start, #end: end}),
          returnValue:
              Future<List<_i2.AssetEntity>>.value(<_i2.AssetEntity>[])) as _i7
          .Future<List<_i2.AssetEntity>>);
  @override
  _i7.Future<List<_i2.AssetPathEntity>> getSubPathList() => (super.noSuchMethod(
          Invocation.method(#getSubPathList, []),
          returnValue:
              Future<List<_i2.AssetPathEntity>>.value(<_i2.AssetPathEntity>[]))
      as _i7.Future<List<_i2.AssetPathEntity>>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [AssetEntity].
///
/// See the documentation for Mockito's code generation for more information.
class MockAssetEntity extends _i1.Mock implements _i2.AssetEntity {
  MockAssetEntity() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: '') as String);
  @override
  set id(String? _id) => super.noSuchMethod(Invocation.setter(#id, _id),
      returnValueForMissingStub: null);
  @override
  set title(String? _title) =>
      super.noSuchMethod(Invocation.setter(#title, _title),
          returnValueForMissingStub: null);
  @override
  int get typeInt =>
      (super.noSuchMethod(Invocation.getter(#typeInt), returnValue: 0) as int);
  @override
  set typeInt(int? _typeInt) =>
      super.noSuchMethod(Invocation.setter(#typeInt, _typeInt),
          returnValueForMissingStub: null);
  @override
  int get duration =>
      (super.noSuchMethod(Invocation.getter(#duration), returnValue: 0) as int);
  @override
  set duration(int? _duration) =>
      super.noSuchMethod(Invocation.setter(#duration, _duration),
          returnValueForMissingStub: null);
  @override
  int get width =>
      (super.noSuchMethod(Invocation.getter(#width), returnValue: 0) as int);
  @override
  set width(int? _width) =>
      super.noSuchMethod(Invocation.setter(#width, _width),
          returnValueForMissingStub: null);
  @override
  int get height =>
      (super.noSuchMethod(Invocation.getter(#height), returnValue: 0) as int);
  @override
  set height(int? _height) =>
      super.noSuchMethod(Invocation.setter(#height, _height),
          returnValueForMissingStub: null);
  @override
  set createDtSecond(int? _createDtSecond) =>
      super.noSuchMethod(Invocation.setter(#createDtSecond, _createDtSecond),
          returnValueForMissingStub: null);
  @override
  set modifiedDateSecond(int? _modifiedDateSecond) => super.noSuchMethod(
      Invocation.setter(#modifiedDateSecond, _modifiedDateSecond),
      returnValueForMissingStub: null);
  @override
  int get orientation =>
      (super.noSuchMethod(Invocation.getter(#orientation), returnValue: 0)
          as int);
  @override
  set orientation(int? _orientation) =>
      super.noSuchMethod(Invocation.setter(#orientation, _orientation),
          returnValueForMissingStub: null);
  @override
  bool get isFavorite =>
      (super.noSuchMethod(Invocation.getter(#isFavorite), returnValue: false)
          as bool);
  @override
  set isFavorite(bool? _isFavorite) =>
      super.noSuchMethod(Invocation.setter(#isFavorite, _isFavorite),
          returnValueForMissingStub: null);
  @override
  set relativePath(String? _relativePath) =>
      super.noSuchMethod(Invocation.setter(#relativePath, _relativePath),
          returnValueForMissingStub: null);
  @override
  set mimeType(String? _mimeType) =>
      super.noSuchMethod(Invocation.setter(#mimeType, _mimeType),
          returnValueForMissingStub: null);
  @override
  _i7.Future<String> get titleAsync =>
      (super.noSuchMethod(Invocation.getter(#titleAsync),
          returnValue: Future<String>.value('')) as _i7.Future<String>);
  @override
  _i4.AssetType get type => (super.noSuchMethod(Invocation.getter(#type),
      returnValue: _i4.AssetType.other) as _i4.AssetType);
  @override
  double get latitude =>
      (super.noSuchMethod(Invocation.getter(#latitude), returnValue: 0.0)
          as double);
  @override
  set latitude(double? latitude) =>
      super.noSuchMethod(Invocation.setter(#latitude, latitude),
          returnValueForMissingStub: null);
  @override
  double get longitude =>
      (super.noSuchMethod(Invocation.getter(#longitude), returnValue: 0.0)
          as double);
  @override
  set longitude(double? longitude) =>
      super.noSuchMethod(Invocation.setter(#longitude, longitude),
          returnValueForMissingStub: null);
  @override
  _i7.Future<_i10.File?> get file =>
      (super.noSuchMethod(Invocation.getter(#file),
          returnValue: Future<_i10.File?>.value()) as _i7.Future<_i10.File?>);
  @override
  _i7.Future<_i10.File?> get originFile =>
      (super.noSuchMethod(Invocation.getter(#originFile),
          returnValue: Future<_i10.File?>.value()) as _i7.Future<_i10.File?>);
  @override
  _i7.Future<_i11.Uint8List?> get fullData =>
      (super.noSuchMethod(Invocation.getter(#fullData),
              returnValue: Future<_i11.Uint8List?>.value())
          as _i7.Future<_i11.Uint8List?>);
  @override
  _i7.Future<_i11.Uint8List?> get originBytes =>
      (super.noSuchMethod(Invocation.getter(#originBytes),
              returnValue: Future<_i11.Uint8List?>.value())
          as _i7.Future<_i11.Uint8List?>);
  @override
  _i7.Future<_i11.Uint8List?> get thumbData =>
      (super.noSuchMethod(Invocation.getter(#thumbData),
              returnValue: Future<_i11.Uint8List?>.value())
          as _i7.Future<_i11.Uint8List?>);
  @override
  Duration get videoDuration =>
      (super.noSuchMethod(Invocation.getter(#videoDuration),
          returnValue: _FakeDuration()) as Duration);
  @override
  _i5.Size get size =>
      (super.noSuchMethod(Invocation.getter(#size), returnValue: _FakeSize())
          as _i5.Size);
  @override
  DateTime get createDateTime =>
      (super.noSuchMethod(Invocation.getter(#createDateTime),
          returnValue: _FakeDateTime()) as DateTime);
  @override
  DateTime get modifiedDateTime =>
      (super.noSuchMethod(Invocation.getter(#modifiedDateTime),
          returnValue: _FakeDateTime()) as DateTime);
  @override
  _i7.Future<bool> get exists => (super.noSuchMethod(Invocation.getter(#exists),
      returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  _i7.Future<_i2.LatLng> latlngAsync() =>
      (super.noSuchMethod(Invocation.method(#latlngAsync, []),
              returnValue: Future<_i2.LatLng>.value(_FakeLatLng()))
          as _i7.Future<_i2.LatLng>);
  @override
  _i7.Future<_i11.Uint8List?> thumbDataWithSize(int? width, int? height,
          {_i4.ThumbFormat? format = _i4.ThumbFormat.jpeg,
          int? quality = 100,
          _i2.PMProgressHandler? progressHandler}) =>
      (super.noSuchMethod(
              Invocation.method(#thumbDataWithSize, [
                width,
                height
              ], {
                #format: format,
                #quality: quality,
                #progressHandler: progressHandler
              }),
              returnValue: Future<_i11.Uint8List?>.value())
          as _i7.Future<_i11.Uint8List?>);
  @override
  _i7.Future<_i10.File?> loadFile(
          {bool? isOrigin = true, _i2.PMProgressHandler? progressHandler}) =>
      (super.noSuchMethod(
          Invocation.method(#loadFile, [],
              {#isOrigin: isOrigin, #progressHandler: progressHandler}),
          returnValue: Future<_i10.File?>.value()) as _i7.Future<_i10.File?>);
  @override
  _i7.Future<_i11.Uint8List?> thumbDataWithOption(_i12.ThumbOption? option,
          {_i2.PMProgressHandler? progressHandler}) =>
      (super.noSuchMethod(
              Invocation.method(#thumbDataWithOption, [option],
                  {#progressHandler: progressHandler}),
              returnValue: Future<_i11.Uint8List?>.value())
          as _i7.Future<_i11.Uint8List?>);
  @override
  _i7.Future<String?> getMediaUrl() =>
      (super.noSuchMethod(Invocation.method(#getMediaUrl, []),
          returnValue: Future<String?>.value()) as _i7.Future<String?>);
  @override
  _i7.Future<_i2.AssetEntity?> refreshProperties() =>
      (super.noSuchMethod(Invocation.method(#refreshProperties, []),
              returnValue: Future<_i2.AssetEntity?>.value())
          as _i7.Future<_i2.AssetEntity?>);
  @override
  String toString() => super.toString();
}
