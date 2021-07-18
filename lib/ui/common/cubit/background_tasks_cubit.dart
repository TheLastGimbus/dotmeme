import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../background/foreground_service/foreground_service_manager.dart';
import 'background_tasks_state.dart';

class BackgroundTasksCubit extends Cubit<BackgroundTasksState?> {
  final _fsm = GetIt.I<ForegroundServiceManager>();
  late StreamSubscription _fsmSub;

  BackgroundTasksCubit() : super(null) {
    _fsmSub = _fsm.receiveStream.listen((event) {
      if (event is ScanTaskState) emit(event);
    });
  }

  Future<bool> startScanTask() => _fsm.startScanService();

  @override
  Future<void> close() async {
    await _fsmSub.cancel();
    await super.close();
  }
}
