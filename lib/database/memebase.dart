import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:moor/ffi.dart';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/folders.dart';
import 'tables/memes.dart';

part 'memebase.g.dart';

@UseMoor(
  tables: [Folders, Memes],
  include: {'tables/memes_fts.moor'},
)
class Memebase extends _$Memebase {
  Memebase(QueryExecutor q) : super(q);

  Memebase.connect(DatabaseConnection conn) : super.connect(conn);

  static const databaseFileName = 'memebase_v1.sqlite';
  static const databasePortName = 'database_isolate_port';

  static LazyDatabase get diskDatabase {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, databaseFileName));
      return VmDatabase(file);
    });
  }

  static VmDatabase get virtualDatabase => VmDatabase.memory();

  /// Creates a new Isolate and returns a corresponding MoorIsolate
  static Future<SendPort> _createMoorIsolate() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, Memebase.databaseFileName));
    final receivePort = ReceivePort();
    await Isolate.spawn(
        _startBackground, _IsolateStartRequest(receivePort.sendPort, file));
    return await receivePort.first as SendPort;
  }

  /// Checks if there is MoorIsolate somewhere in there - for example,
  /// maintained by a running foreground service - if there is, connects to it ;
  /// if not, creates a new one
  // Heavily inspired by: https://moor.simonbinder.eu/docs/advanced-features/isolates/
  static Memebase getBackgroundDatabase() {
    final log = GetIt.I<Logger>();
    // Check if there is
    final dbPort =
        IsolateNameServer.lookupPortByName(Memebase.databasePortName);
    log.d("Isolate ${Isolate.current.hashCode}: " +
        (dbPort == null
            ? "dbPort not found - creating isolate..."
            : "dbPort found! Connecting to it..."));
    return Memebase.connect(
      DatabaseConnection.delayed(() async {
        return MoorIsolate.fromConnectPort(dbPort ?? await _createMoorIsolate())
            .connect();
      }()),
    );
  }

  @override
  int get schemaVersion => 1;
}

// Methods for starting database in the background. Heavily inspired by:
// https://moor.simonbinder.eu/docs/advanced-features/isolates/#initialization-on-the-main-thread

/// Simple class to bundle stuff for Isolate.spawn()
class _IsolateStartRequest {
  final SendPort sendMoorIsolate;
  final File targetPath;

  _IsolateStartRequest(this.sendMoorIsolate, this.targetPath);
}

// MUST be a top-level function
void _startBackground(_IsolateStartRequest request) {
  final moorIsolate = MoorIsolate.inCurrent(
      () => DatabaseConnection.fromExecutor(VmDatabase(request.targetPath)));
  IsolateNameServer.registerPortWithName(
      moorIsolate.connectPort, Memebase.databasePortName);
  request.sendMoorIsolate.send(moorIsolate.connectPort);
}
