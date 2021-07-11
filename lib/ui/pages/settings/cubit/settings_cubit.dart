import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../database/memebase.dart';
import '../../../../database/queries.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final Memebase db;
  StreamSubscription? _foldersWatch;

  SettingsCubit(this.db) : super(SettingsLoadingState()) {
    _init();
  }

  void _init() async {
    _foldersWatch?.cancel();
    _foldersWatch = db
        .allFoldersMemeCounts()
        .watch()
        .listen((event) => emit(SettingsLoadedState(event)));
  }

  Future<void> setFolderEnabled(int id, bool enabled) =>
      db.setFolderEnabled(id, enabled);

  @override
  Future<void> close() async {
    await _foldersWatch?.cancel();
    return super.close();
  }
}
