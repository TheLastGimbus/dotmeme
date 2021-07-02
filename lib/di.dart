import 'package:get_it/get_it.dart';

import 'database/memebase.dart';

GetIt getIt = GetIt.instance;

enum Environment { prod, test }

/// Initializes all singletons that will provide us data/stuff
/// Decide whether you want fake data or real one with [env]
void init(Environment env) {
  if (env == Environment.prod) {
    getIt
        .registerLazySingleton<Memebase>(() => Memebase(Memebase.diskDatabase));
  } else if (env == Environment.test) {
    getIt.registerLazySingleton<Memebase>(
        () => Memebase(Memebase.virtualDatabase));
  }
}
