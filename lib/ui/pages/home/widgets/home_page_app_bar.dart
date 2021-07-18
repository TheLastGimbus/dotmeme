import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/cubit/background_tasks_cubit.dart';
import '../../../common/cubit/background_tasks_state.dart';
import '../../settings/settings_page.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskState = context.watch<BackgroundTasksCubit>().state;
    return AppBar(
      title: Column(
        children: [
          const Text("dotmeme"),
          if (taskState is ScanTaskState)
            Text(
              "Scanning: "
              "${taskState.scannedAllCount}/${taskState.allCount}",
            ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.of(context).push(SettingsPage.route()),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
