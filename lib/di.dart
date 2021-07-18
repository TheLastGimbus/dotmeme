import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';

import 'background/foreground_service/foreground_service_manager.dart';
import 'database/memebase.dart';
import 'device_media/media_manager.dart';
import 'device_media/mock_media_manager.dart';

GetIt getIt = GetIt.instance;

enum Environment { prod, prodBackground, test }

/// This is useful when dealing with multiple isolates
bool get isInitialized => _isInitialized;
bool _isInitialized = false;

/// Initializes all singletons that will provide us data/stuff
/// Decide whether you want fake data or real one with [env]
void init(Environment env) {
  if (env == Environment.prod || env == Environment.prodBackground) {
    if (env == Environment.prodBackground) {
      getIt.registerLazySingleton<Memebase>(
        () => Memebase.connect(
          DatabaseConnection.delayed(
            MoorIsolate.inCurrent(
              () => DatabaseConnection.fromExecutor(Memebase.diskDatabase),
            ).connect(),
          ),
        ),
        dispose: (db) => db.close(),
      );
    } else {
      getIt.registerLazySingleton<Memebase>(
        () => Memebase(Memebase.diskDatabase),
        dispose: (db) => db.close(),
      );
    }
    getIt.registerSingleton<MediaManager>(MediaManager());
    getIt.registerSingleton<Logger>(
      Logger(
        filter: ProductionFilter()..level = Level.verbose,
      ),
    );
    // This must be lazy, otherwise it doesn't work
    getIt.registerLazySingleton<ForegroundServiceManager>(
      () => ForegroundServiceManager(),
      dispose: (fsm) => fsm.dispose(),
    );
  } else if (env == Environment.test) {
    getIt.registerLazySingleton<Memebase>(
      () => Memebase(Memebase.virtualDatabase),
      dispose: (db) => db.close(),
    );
    getIt.registerSingleton<MediaManager>(MockMediaManager());
    getIt.registerSingleton<Logger>(
      Logger(
        filter: DevelopmentFilter()..level = Level.verbose,
      ),
    );
    // TODO: MockForegroundServiceManager
  }
  _isInitialized = true;
}

Future<void> dispose() => getIt.reset();
