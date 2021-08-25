import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../database/media_sync.dart';
import '../../../database/memebase.dart';

/// This cubit is big brain of syncing memes from device to db (while app open)
///
/// All events that require sync (HomePage opened etc) should be available
/// as it's methods
///
/// However, we also need to do similar things when in background, so any
/// independent logic of it should also be moved to different (non-cubit) place
class MediaSyncCubit extends Cubit<void> {
  final db = GetIt.I<Memebase>();

  MediaSyncCubit() : super(null);

  /// Execute when user opens app
  void appOpenSync() async {
    final devFolders = await MediaSync.getMediaFolders();
    db.setupFileWatchers(devFolders); // Don't await it, just go
    await db.enabledFoldersMemeSync(devFolders);
    await db.foldersSync(devFolders);
    // Idk how to do this better
    // TODO: Test if this doesn't lag the app
    await db.disabledFoldersMemeSync(devFolders);
  }

  @override
  Future<void> close() async {
    await db.closeFileWatchers();
    return await super.close();
  }
}
