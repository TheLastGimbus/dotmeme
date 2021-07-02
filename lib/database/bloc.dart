import 'package:flutter_bloc/flutter_bloc.dart';

import 'memebase.dart';

class DbCubit extends Cubit<Memebase> {
  DbCubit() : super(Memebase());
}
