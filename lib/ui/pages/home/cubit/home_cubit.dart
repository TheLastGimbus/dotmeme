import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import 'home_state.dart';

/// This cubit manages what's visible on home page meme roll
/// - storage permission, first and foremost
/// - getting all memes (whole roll)
/// - managing any filters that could be there (only videos, etc)
///   (this possibly should go to some other cubit)
/// - results from search even?

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoadingState()) {
    init();
  }

  /// Check permissions
  /// Load memes
  /// TODO: Replace this with database
  void init() async {
    final res = await PhotoManager.requestPermissionExtend();
    if (!res.isAuth) {
      emit(HomeNoPermissionState());
      return;
    }
    final all = await PhotoManager.getAssetPathList(onlyAll: true);
    // TODO: Pagination/smth - it's, indeed, much faster
    emit(HomeSuccessState(await all.first.assetList));
  }
}
