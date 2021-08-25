/// This file contains some flags (for now, passed with `--dart-define` - in
/// future, maybe with other ways) that modify how code runs etc

/// Run everything you can on UI isolate. It saves a lot of time because
/// hot reload/restart doesn't work in other isolates (even if you kill them!)
bool get singleIsolate => const bool.fromEnvironment("SINGLE_ISOLATE");
