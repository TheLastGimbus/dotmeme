import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../database/memebase.dart';
import '../../../../database/queries.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final Memebase db;
  List<MapEntry<Folder, int>> _state = [];

  SettingsCubit(this.db) : super(SettingsLoadingState()) {
    _init();
  }

  void _init() async {
    final fol = await db.allFolders;
    _state = await Future.wait(fol
        .map((e) async => MapEntry(e, await db.folderMemesCount(e.id)))
        .toList());
    emit(SettingsLoadedState(_state));
  }

  Future<void> setFolderEnabled(int id, bool enabled) async {
    await db.setFolderEnabled(id, enabled);
    final i = _state.indexWhere((e) => e.key.id == id);
    _state = _state.toList();  // Cubit and equality :/
    _state[i] = MapEntry(
        _state[i].key.copyWith(scanningEnabled: enabled), _state[i].value);
    emit(SettingsLoadedState(_state));
  }
}
