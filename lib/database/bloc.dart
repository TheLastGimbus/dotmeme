import 'package:flutter_bloc/flutter_bloc.dart';

import 'memebase.dart';

// I don't know if we still need this if we have DI
// I'll leave it for now
class DbCubit extends Cubit<Memebase> {
  final Memebase db;

  DbCubit(this.db) : super(db);

  @override
  Future<void> close() async {
    // I'm not sure about this lifecycle - we may need to close it somewhere else
    await db.close();
    await super.close();
  }
}
