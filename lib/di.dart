import 'package:get_it/get_it.dart';

import 'database/memebase.dart';
import 'device_media/media_manager.dart';
import 'device_media/mock_media_manager.dart';

GetIt getIt = GetIt.instance;

enum Environment { prod, test }

/// Initializes all singletons that will provide us data/stuff
/// Decide whether you want fake data or real one with [env]
void init(Environment env) {
  if (env == Environment.prod) {
    getIt
        .registerLazySingleton<Memebase>(() => Memebase(Memebase.diskDatabase));
    getIt.registerSingleton<MediaManager>(MediaManager());
  } else if (env == Environment.test) {
    getIt.registerLazySingleton<Memebase>(
        () => Memebase(Memebase.virtualDatabase));
    getIt.registerSingleton<MediaManager>(getMockManager());
  }
}
