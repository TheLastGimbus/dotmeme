import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../database/media_sync.dart';
import '../../../../database/memebase.dart';

class BenchmarkPage extends StatefulWidget {
  const BenchmarkPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const BenchmarkPage());

  @override
  _BenchmarkPageState createState() => _BenchmarkPageState();
}

class _BenchmarkPageState extends State<BenchmarkPage> {
  final db = GetIt.I<Memebase>();

  // TODO: Change this to MediaSyncCubit
  final Future<List<AssetPathEntity>> _deviceFolders =
      MediaSync.getMediaFolders();
  int? _timeFoldersSync;
  int? _timeEnabledFoldersMemeSync;
  int? _timeAllFoldersMemeSync;

  Future<int> _time(Function func) async {
    final w = Stopwatch()..start();
    await func();
    return w.elapsedMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Benchmark page")),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Text("Time folderSync: ${_timeFoldersSync}ms"),
          Text("Enabled folders meme sync: ${_timeEnabledFoldersMemeSync}ms"),
          Text("All folders meme sync: ${_timeAllFoldersMemeSync}ms"),
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
        ],
      ),
    );
  }
}
