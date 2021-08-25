import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config_flags.dart' as flags;
import 'di.dart' as di;
import 'ui/common/cubit/background_tasks_cubit.dart';
import 'ui/common/cubit/common_cache_cubit.dart';
import 'ui/common/cubit/media_sync_cubit.dart';
import 'ui/common/theme/theme.dart' as theme;
import 'ui/pages/home/home_page.dart';

void main() {
  // ignore: avoid_print
  print(
    "Starting app with flags:\n"
    "\tsingleIsolate: ${flags.singleIsolate}",
  );
  di.init(di.Environment.prod);

  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MediaSyncCubit()),
        BlocProvider(create: (_) => BackgroundTasksCubit()),
        BlocProvider(create: (_) => CommonCacheCubit())
      ],
      child: MaterialApp(
        title: 'dotmeme',
        theme: theme.lightTheme,
        home: const HomePage(),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      di.dispose();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}
