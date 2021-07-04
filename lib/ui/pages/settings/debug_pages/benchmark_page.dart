import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../database/bloc.dart';
import '../../../../database/media_sync.dart';

class BenchmarkPage extends StatefulWidget {
  const BenchmarkPage({Key? key}) : super(key: key);

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const BenchmarkPage());

  @override
  _BenchmarkPageState createState() => _BenchmarkPageState();
}

class _BenchmarkPageState extends State<BenchmarkPage> {
  int? _timeFoldersSync;
  int? _timeEnabledFoldersMemeSync;

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
          ElevatedButton(
            onPressed: () async {
              _timeFoldersSync = await _time(db.foldersSync);
              setState(() {});
            },
            child: const Text("Folders sync"),
          ),
          ElevatedButton(
            onPressed: () async {
              _timeEnabledFoldersMemeSync =
                  await _time(db.enabledFoldersMemeSync);
              setState(() {});
            },
            child: const Text("Enabled folders meme sync"),
          ),
        ],
      ),
    );
  }
}
