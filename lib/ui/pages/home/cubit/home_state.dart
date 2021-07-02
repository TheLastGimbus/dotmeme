import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class HomeState {}

class HomeLoadingState implements HomeState {}

class HomeSuccessState extends Equatable implements HomeState {
  /// All memes that are visible right now
  final List<AssetEntity> assetEntities;

  HomeSuccessState(this.assetEntities);

  @override
  List<Object?> get props => [assetEntities];
}

class HomeNoPermissionState implements HomeState {}
