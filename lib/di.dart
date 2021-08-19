import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'analysis/vision/ocr/ocr_scanner.dart';
import 'analysis/vision/ocr/terminal_ocr_scanner.dart';
import 'background/foreground_service/foreground_service_manager.dart';
import 'background/foreground_service/mock_foreground_service_manager.dart';
import 'database/memebase.dart';
import 'device_media/media_manager.dart';
import 'device_media/mock_media_manager.dart';

GetIt getIt = GetIt.instance;

enum Environment { prod, test }

/// This is useful when dealing with multiple isolates
bool get isInitialized => _isInitialized;
bool _isInitialized = false;

/// Initializes all singletons that will provide us data/stuff
/// Decide whether you want fake data or real one with [env]
void init(Environment env) {
  if (env == Environment.prod) {
    getIt.registerLazySingleton<Memebase>(
      () => Memebase.getBackgroundDatabase(),
      dispose: (db) => db.close(),
    );
    getIt.registerSingleton<MediaManager>(MediaManager());
    getIt.registerSingleton<Logger>(
      Logger(
        filter: ProductionFilter()..level = Level.verbose,
      ),
    );
    // This must be lazy, otherwise it doesn't work
    getIt.registerLazySingleton<ForegroundServiceManager>(
      // Save few hours wasted on re-installing the app
      // Because hot-reload doesn't work in FServices
      () => kDebugMode
          ? MockForegroundServiceManager()
          : ForegroundServiceManager(),
      dispose: (fsm) => fsm.dispose(),
    );
    getIt.registerLazySingleton<OcrScanner>(() => OcrScanner());
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
    getIt.registerLazySingleton<ForegroundServiceManager>(
      () => MockForegroundServiceManager(),
      dispose: (fsm) => fsm.dispose(),
    );
    getIt.registerLazySingleton<OcrScanner>(() => TerminalOcrScanner());
  }
  _isInitialized = true;
}

Future<void> dispose() => getIt.reset();
