import 'package:equatable/equatable.dart';

import '../../../../database/memebase.dart';

abstract class SettingsState {}

class SettingsLoadingState implements SettingsState {}

class SettingsLoadedState extends Equatable implements SettingsState {
  // Folders and their media count
  // TODO: Change this somehow
  final List<MapEntry<Folder, int>> folders;

  const SettingsLoadedState(this.folders);

  @override
  List<Object> get props => [folders];
}