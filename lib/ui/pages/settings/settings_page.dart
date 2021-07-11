import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../database/bloc.dart';
import 'cubit/settings_cubit.dart';
import 'cubit/settings_state.dart';
import 'debug_pages/benchmark_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // I don't know if this is the way we will route, probably not
  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const SettingsPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(context.watch<DbCubit>().state),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Settings")),
          body: context.watch<SettingsCubit>().state is SettingsLoadedState
              ? const _LoadedBody()
              : const Center(child: Text("Loading...")),
        ),
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({Key? key}) : super(key: key);

  // This is very, very much TODO
  @override
  Widget build(BuildContext context) {
    final cbt = context.watch<SettingsCubit>();
    final state = cbt.state as SettingsLoadedState;
    // Idk if we should use pre-made settings - probably should make our own
    return SettingsList(
      sections: [
        // Hide this later in release
        SettingsSection(
          title: "Debug stuff",
          tiles: [
            SettingsTile(
              title: "Benchmark page",
              onPressed: (context) =>
                  Navigator.of(context).push(BenchmarkPage.route()),
            ),
            SettingsTile(
              title: "Enable all folders",
              onPressed: (_) {
                for (final f in state.folders) {
                  cbt.setFolderEnabled(f.key.id, true);
                }
              },
            ),
            SettingsTile(
              title: "Disable all folders",
              onPressed: (_) {
                for (final f in state.folders) {
                  cbt.setFolderEnabled(f.key.id, false);
                }
              },
            ),
          ],
        ),
        SettingsSection(
          title: "Enabled folders",
          subtitle: const Text("Which folders should be scanned and showed"),
          tiles: [
            for (final folder in state.folders)
              SettingsTile.switchTile(
                switchValue: folder.key.scanningEnabled,
                onToggle: (val) => cbt.setFolderEnabled(folder.key.id, val),
                title: folder.key.name,
                subtitle: folder.value.toString(),
              ),
          ],
        ),
      ],
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
    );
  }
}
