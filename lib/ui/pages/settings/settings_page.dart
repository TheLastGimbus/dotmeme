import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../database/bloc.dart';
import 'cubit/settings_cubit.dart';
import 'cubit/settings_state.dart';

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
    return ListView(
      children: [
        Text("Folder settings", style: Theme.of(context).textTheme.headline3),
        Column(
          children: [
            for (final folder in state.folders)
              SwitchListTile(
                value: folder.key.scanningEnabled,
                onChanged: (val) => cbt.setFolderEnabled(folder.key.id, val),
                title: Text(folder.key.name),
                subtitle: Text(folder.value.toString()),
              ),
          ],
        ),
      ],
    );
  }
}
