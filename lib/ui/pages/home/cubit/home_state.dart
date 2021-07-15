import 'package:equatable/equatable.dart';

import '../../../../database/memebase.dart';

abstract class HomeState {}

class HomeLoadingState implements HomeState {}

class HomeSuccessState extends Equatable implements HomeState {
  /// All memes that are visible right now
  final List<Meme> memes;

  const HomeSuccessState(this.memes);

  @override
  List<Object?> get props => [memes];
}
