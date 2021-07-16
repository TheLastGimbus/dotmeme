# *The background*

Okay, so as you may know, our app needs to some heavy calculations - ideally, in the background...

Some of these are short enough to do them in scheduled task, some are longer, and need to be moved to a foreground service

Ideally, *all* of them should be exposed as classes/functions/stuff independent of plugins (at least background'ish once) - could be run in normal UI mode

There should also be some mechanism that decides if we want to do stuff in scheduled task (those should finish in <1 minute-something or the OS will get mad) or we should move the job to foreground service (can pretty much run indefinitely, but we also want some battery-awareness there)

## Foreground service

The code that you should interact with in the rest of the UI app is `ForegroundServiceManager`, got from GetIt. It manages Isolate connections, etc.

For more details, read the documentation inside the files in `foreground_service/` folder
