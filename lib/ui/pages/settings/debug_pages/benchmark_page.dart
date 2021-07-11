import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../database/bloc.dart';
import '../../../../database/blurhash.dart';
import '../../../../database/media_sync.dart';

class BenchmarkPage extends StatefulWidget {
  const BenchmarkPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const BenchmarkPage());

  @override
  _BenchmarkPageState createState() => _BenchmarkPageState();
}

class _BenchmarkPageState extends State<BenchmarkPage> {
  // TODO: Change this to MediaSyncCubit
  final Future<List<AssetPathEntity>> _deviceFolders =
      MediaSync.getMediaFolders();
  int? _timeFoldersSync;
  int? _timeEnabledFoldersMemeSync;
  int? _timeAllFoldersMemeSync;
  int? _timeEncodeBlurhashes;

  Future<int> _time(Function func) async {
    final w = Stopwatch()..start();
    await func();
    return w.elapsedMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<DbCubit>().state;
    return Scaffold(
      appBar: AppBar(title: const Text("Benchmark page")),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Text("Time folderSync: ${_timeFoldersSync}ms"),
          Text("Enabled folders meme sync: ${_timeEnabledFoldersMemeSync}ms"),
          Text("All folders meme sync: ${_timeAllFoldersMemeSync}ms"),
          Text("Encode blurhashes: ${_timeEncodeBlurhashes}ms"),
          ElevatedButton(
            onPressed: () async {
              _timeFoldersSync =
                  await _time(() async => db.foldersSync(await _deviceFolders));
              setState(() {});
            },
            child: const Text("Folders sync"),
          ),
          ElevatedButton(
            onPressed: () async {
              _timeEnabledFoldersMemeSync = await _time(
                  () async => db.enabledFoldersMemeSync(await _deviceFolders));
              setState(() {});
            },
            child: const Text("Enabled folders meme sync"),
          ),
          ElevatedButton(
            onPressed: () async {
              _timeAllFoldersMemeSync = await _time(
                  () async => db.allFoldersMemeSync(await _deviceFolders));
              setState(() {});
            },
            child: const Text("All folders meme sync"),
          ),
          ElevatedButton(
            onPressed: () async {
              _timeEncodeBlurhashes =
                  await _time(() async => await db.encodeBlurhashes().last);
              setState(() {});
            },
            child: const Text("Encode blurhashes"),
          )
        ],
      ),
    );
  }
}
