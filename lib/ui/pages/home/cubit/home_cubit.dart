import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../database/memebase.dart';
import '../../../../database/queries.dart';
import '../../../../database/search.dart';
import 'home_state.dart';

/// This cubit manages what's visible on home page meme roll
/// - getting all memes (whole roll)
/// - managing any filters that could be there (only videos, etc)
///   (this possibly should go to some other cubit)
/// - results from search even?

class HomeCubit extends Cubit<HomeState> {
  final Memebase db;
  StreamSubscription? _selectedMemesStream;

  HomeCubit(this.db) : super(HomeLoadingState()) {
    allMemes();
  }

  /// Load memes
  void allMemes() async {
    await _selectedMemesStream?.cancel();
    _selectedMemesStream =
        db.allMemes.watch().listen((event) => emit(HomeSuccessState(event)));
  }

  Future<void> search(String userInput) async {
    await _selectedMemesStream?.cancel();
    // We don't use .watch() because experience could be poor if it was
    // scanning in background
    final w = Stopwatch()..start();
    emit(HomeSuccessState(await db.searchMemes(userInput).get()));
    // ignore: avoid_print
    print('Search took ${w.elapsedMilliseconds}ms');
  }

  @override
  Future<void> close() async {
    await _selectedMemesStream?.cancel();
    await super.close();
  }
}
