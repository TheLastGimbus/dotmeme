import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../database/bloc.dart';
import '../../../database/memebase.dart';
import '../../../device_media/media_manager.dart';
import '../../common/cubit/media_sync_cubit.dart';
import '../settings/settings_page.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Idk if this is safe
    context.read<MediaSyncCubit>().appOpenSync();
    return BlocProvider(
      create: (_) => HomeCubit(context.watch<DbCubit>().state),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeCubit>().state;
    Widget body = const _LoadingBody();
    // Omg google why can't you just add switch-as-statement
    // like normal Kotlin people do
    if (state is HomeLoadingState) {
      body = const _LoadingBody();
    } else if (state is HomeNoPermissionState) {
      body = const _NoPermissionBody();
    } else if (state is HomeSuccessState) {
      body = _SuccessBody(state);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("dotmeme"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(SettingsPage.route()),
          )
        ],
      ),
      body: body,
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Nice loading animation
    return Center(
      child: Column(
        children: const [
          Text("Loading..."),
          Icon(Icons.autorenew),
        ],
      ),
    );
  }
}

class _NoPermissionBody extends StatelessWidget {
  const _NoPermissionBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("App doesn't have permission for photos :("),
          TextButton(
            onPressed: () => context.read<HomeCubit>().init(),
            child: const Text("Give permission"),
          ),
          TextButton(
            onPressed: () => GetIt.I<MediaManager>().openSetting(),
            child: const Text("Go to settings"),
          ),
        ],
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  final HomeSuccessState state;

  const _SuccessBody(this.state, {Key? key}) : super(key: key);

  Future<Uint8List?> _getThumb(Meme meme) async {
    final ass =
        await GetIt.I<MediaManager>().assetEntityFromId(meme.id.toString());
    return ass?.thumbData;
  }

  @override
  Widget build(BuildContext context) {
    return state.memes.isNotEmpty
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: _getThumb(state.memes[index]),
                builder: (_, AsyncSnapshot<Uint8List?> snap) => snap.hasData
                    ? snap.data != null
                        ? Image.memory(snap.data!, fit: BoxFit.cover)
                        : const Text("No meme! Where funny??")
                    : const Icon(Icons.autorenew),
              );
            },
            itemCount: state.memes.length,
            cacheExtent: 200,
          )
        : const Center(
            child: Text("You don't have any memes :/"),
          );
  }
}
