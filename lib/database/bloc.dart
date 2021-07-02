import 'package:flutter_bloc/flutter_bloc.dart';

import 'memebase.dart';

// I don't know if we still need this if we have DI
// I'll leave it for now
class DbCubit extends Cubit<Memebase> {
  DbCubit(Memebase db) : super(db);
}
