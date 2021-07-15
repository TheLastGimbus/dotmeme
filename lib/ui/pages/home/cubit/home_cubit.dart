import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../database/memebase.dart';
import '../../../../database/queries.dart';
import 'home_state.dart';

/// This cubit manages what's visible on home page meme roll
/// - getting all memes (whole roll)
/// - managing any filters that could be there (only videos, etc)
///   (this possibly should go to some other cubit)
/// - results from search even?

class HomeCubit extends Cubit<HomeState> {
  final Memebase db;
  StreamSubscription? _allMemesStream;

  HomeCubit(this.db) : super(HomeLoadingState()) {
    init();
  }

  /// Load memes
  void init() async {
    // Start fetching them in background already (don't wait for permission)
    _allMemesStream?.cancel();
    _allMemesStream = db.allMemes.watch().listen((event) async {
      // ...but wait before displaying them
        emit(HomeSuccessState(event));
    });
  }

  @override
  Future<void> close() async {
    await _allMemesStream?.cancel();
    await super.close();
  }
}
