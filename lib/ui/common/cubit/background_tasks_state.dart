import 'package:equatable/equatable.dart';

abstract class BackgroundTasksState {}

/// Memes are being scanned right now
class ScanTaskState extends Equatable implements BackgroundTasksState {
  /// Folder that is currently scanned
  final int currentFolderId;

  /// Meme that is scanned right not
  final int currentMemeId;

  /// All memes that are already scanned
  final int scannedAllCount;

  /// All memes from current folder that are already scanned
  final int scannedFolderCount;

  /// All memes that are scan-able (including those that are ready)
  final int allCount;

  /// All memes from current folder that are scan-able
  /// (including those that are ready)
  final int folderCount;

  const ScanTaskState(
    this.currentFolderId,
    this.currentMemeId,
    this.scannedAllCount,
    this.scannedFolderCount,
    this.allCount,
    this.folderCount,
  );

  @override
  List<Object> get props => [
        currentFolderId,
        currentMemeId,
        scannedAllCount,
        scannedFolderCount,
        allCount,
        folderCount,
      ];
}
