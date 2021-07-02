import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../database/bloc.dart';
import '../../../database/memebase.dart';
import '../settings/settings_page.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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


        children: [Text("Loading..."), Icon(Icons.autorenew)],),
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
            onPressed: () => PhotoManager.openSetting(),
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

  Future<File?> _getFile(Meme meme) async {
    final ass = await AssetEntity.fromId(meme.id.toString());
    return ass?.file;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Memes grid
    return ListView.builder(
      itemCount: state.memes.length,
      itemBuilder: (context, index) {
        return AspectRatio(
          aspectRatio: 1 / 2,
          child: FutureBuilder(
            future: _getFile(state.memes[index]),
            builder: (_, AsyncSnapshot<File?> snap) => snap.hasData
                ? snap.data != null
                    ? Image.file(snap.data!)
                    : const Text("No meme! Where funny??")
                : const Icon(Icons.autorenew),
          ),
        );
      },
    );
  }
}
