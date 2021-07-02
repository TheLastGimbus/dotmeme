import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../database/memebase.dart';
import '../../../../device_media/media_manager.dart';
import 'home_state.dart';

/// This cubit manages what's visible on home page meme roll
/// - storage permission, first and foremost
/// - getting all memes (whole roll)
/// - managing any filters that could be there (only videos, etc)
///   (this possibly should go to some other cubit)
/// - results from search even?

class HomeCubit extends Cubit<HomeState> {
  final Memebase db;

  HomeCubit(this.db) : super(HomeLoadingState()) {
    init();
  }

  /// Check permissions
  /// Load memes
  void init() async {
    final memes = db.allMemes; // Start fetching them in background already
    // IDEA: Move this out to some abstraction to later swap it with
    // getIt for testing?
    final res =
        GetIt.I<MediaManager>().requestPermissionExtend().then((v) => v.isAuth);

    if (!await res) {
      emit(HomeNoPermissionState());
      return;
    }
    emit(HomeSuccessState(await memes));
  }
}
