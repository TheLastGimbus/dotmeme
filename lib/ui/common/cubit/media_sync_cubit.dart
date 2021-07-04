import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../database/media_sync.dart';
import '../../../database/memebase.dart';
import '../../../device_media/media_manager.dart';

class MediaSyncCubit extends Cubit<void> {
  final Memebase db;
  final _mm = GetIt.I<MediaManager>();

  MediaSyncCubit(this.db) : super(null) {}

  void appOpenSync() async {
    final devFolders = await MediaSync.getMediaFolders();
    await db.enabledFoldersMemeSync(devFolders);
    await db.foldersSync(devFolders);
  }

  @override
  Future<void> close() async {
    // File watchers close
    return await super.close();
  }
}
