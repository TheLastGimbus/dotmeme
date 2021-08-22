import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:memoize/memoize.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../device_media/media_manager.dart';

/// This cubit keeps cache of common things that we would want to access across
/// the app. File objects, thumbnails, etc
class CommonCacheCubit extends Cubit<void> {
  final _mm = GetIt.I<MediaManager>();

  CommonCacheCubit() : super(null) {
    // Those are functions from package:memoize
    // They cache their output by remembering all input parameters they seen
    getAssetEntityWithCache = memo1(
      (int memeId) => _mm.assetEntityFromId(memeId.toString()),
      maxSize: 5000, // Those are very light
    );
    getThumbWithCache = memo1(
      (int memeId) async {
        final ass = await getAssetEntityWithCache(memeId);
        return ass?.thumbData;
      },
      maxSize: 500, // ...those not so much
    );
    // TODO: WARNING: I'm not sure if this is safe...
    getFileWithCache = memo1(
      (int memeId) async {
        final ass = await getAssetEntityWithCache(memeId);
        return ass?.file;
      },
      maxSize: 5000,
    );
    getImageWithCache = memo1(
      (int memeId) async {
        final file = await getFileWithCache(memeId);
        return file?.readAsBytes();
      },
      maxSize: 50,
    );
  }

  late Future<AssetEntity?> Function(int) getAssetEntityWithCache;
  late Future<Uint8List?> Function(int) getThumbWithCache;
  late Future<File?> Function(int) getFileWithCache;
  late Future<Uint8List?> Function(int) getImageWithCache;
}
