import 'package:dotmeme/ui/pages/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../settings/settings_page.dart';
import 'cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeCubit>().state;
    Widget body = _LoadingBody();
    // Omg google why can't you just add switch-as-statement
    // like normal Kotlin people do
    if (state is HomeLoadingState) {
      body = _LoadingBody();
    } else if (state is HomeNoPermissionState) {
      body = _NoPermissionBody();
    } else if (state is HomeSuccessState) {
      body = _SuccessBody();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("dotmeme"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
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
    return Center(child: Text("Loading..."));
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
          Text("App doesn't have permission for photos :("),
          TextButton(
            onPressed: () => context.read<HomeCubit>().init(),
            child: Text("Give permission"),
          ),
          TextButton(
            onPressed: () => PhotoManager.openSetting(),
            child: Text("Go to settings"),
          ),
        ],
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Memes grid
    return Center(child: Text("Success!!"));
  }
}
