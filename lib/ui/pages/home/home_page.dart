/// Here is the main home page
/// It is very important, because it manages the file storage permission
/// It does it simple and straightforward - if user gives permission, then go on
/// with the app. But if not, beg him to give it, and don't let him go anywhere
/// else!
///
/// This way, we don't need to worry about it *anywhere else* in the app - yay!
/// // This may bite back when we will want to do some crazy shit like
///    "press on notification -> go to a specific page"
///    but we'll figure that out :D
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../database/memebase.dart';
import '../../../device_media/media_manager.dart';
import '../../common/cubit/common_cache_cubit.dart';
import '../../common/cubit/media_sync_cubit.dart';
import '../swiping/swiping_page.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import 'widgets/home_page_app_bar.dart';
import 'widgets/permission_pages.dart' as pp;
import 'widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? _hasPermission;
  final _mm = GetIt.I<MediaManager>();

  _permission() async {
    final req = await _mm.requestPermissionExtend();
    _hasPermission = req == PermissionState.authorized;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // TODO: It would be nice to have some .hasPermission() method
    // to first ask the user gently
    _permission();
  }

  @override
  Widget build(BuildContext context) {
    return _hasPermission != null
        ? _hasPermission!
            ? BlocProvider(
                create: (_) => HomeCubit(),
                child: const HomeView(),
              )
            : pp.NoPermissionPage(
                onRequestPermissionPressed: _permission,
                onOpenSettingsPressed: _mm.openSetting,
              )
        : const pp.WaitingForPermissionPage();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<MediaSyncCubit>().appOpenSync();
  }

  @override
  Widget build(BuildContext context) {
    final homeCbt = context.watch<HomeCubit>();
    final state = homeCbt.state;
    Widget body = const _LoadingBody();
    // Omg google why can't you just add switch-as-statement
    // like normal Kotlin people do
    if (state is HomeLoadingState) {
      body = const _LoadingBody();
    } else if (state is HomeSuccessState) {
      body = _SuccessBody(state);
    }
    return Scaffold(
      appBar: const HomePageAppBar(),
      body: Stack(
        children: [
          body,
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SearchBar(
                onChanged: (text) => text.trim().isNotEmpty
                    ? homeCbt.search(text)
                    : homeCbt.allMemes(),
              ),
            ),
          ),
        ],
      ),
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

class _SuccessBody extends StatelessWidget {
  final HomeSuccessState state;

  const _SuccessBody(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.memes.isNotEmpty
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (context, index) => GestureDetector(
              child: Container(
                margin: const EdgeInsets.all(0.5),
                child: _memeThumbnail(context, state.memes[index]),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      SwipingPage(memes: state.memes, initialIndex: index),
                ),
              ),
            ),
            itemCount: state.memes.length,
            cacheExtent: 200,
          )
        : const Center(
            child: Text("You don't have any memes :/"),
          );
  }

  Widget _memeThumbnail(BuildContext context, Meme meme) {
    return FutureBuilder(
      future: context.read<CommonCacheCubit>().getThumbWithCache(meme.id),
      builder: (_, AsyncSnapshot<Uint8List?> snap) => snap.hasData
          ? snap.data != null
              ? Image.memory(snap.data!, fit: BoxFit.cover)
              : const Text("No meme! Where funny??")
          : const Icon(Icons.autorenew),
    );
  }
}
