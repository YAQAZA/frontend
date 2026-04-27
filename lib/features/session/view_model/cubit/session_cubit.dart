import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/models/alert_type.dart';
import '../../model/repositories/session_repository.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._repository) : super(const SessionInitial());

  final SessionRepository _repository;

  Timer? _timer;
  int _tick = 0;
  bool _alertActive = false;
  String _sessionId = '';

  Future<void> startSession() async {
    await _stopTimer();

    _tick = 0;
    _alertActive = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();

    emit(const SessionStarting());

    final metrics = await _repository.getMetrics(tick: _tick);

    emit(SessionActive(
      elapsed: Duration.zero,
      metrics: metrics,
      alertType: AlertType.none,
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      _tick++;

      final metrics = await _repository.getMetrics(tick: _tick);
      final elapsed = Duration(seconds: _tick);

      await _repository.syncPendingLogsIfOnline();

      if (metrics.alert != AlertType.none && !_alertActive) {
        _alertActive = true;

        await _repository.saveAlertLog(
          sessionId: _sessionId,
          alertType: metrics.alert,
          elapsed: elapsed,
          sleepinessProbability: metrics.sleepinessProbability,
          severity: metrics.status,
          description: metrics.description,
          imageURL: metrics.imageURL,
        );

        emit(SessionActive(
          elapsed: elapsed,
          metrics: metrics,
          alertType: metrics.alert,
        ));

        return;
      }

      emit(SessionActive(
        elapsed: elapsed,
        metrics: metrics,
        alertType: AlertType.none,
      ));
    });
  }

  Future<void> pauseSession() async {
    final current = state;
    if (current is! SessionActive) return;

    await _stopTimer();

    emit(SessionPaused(
      elapsed: current.elapsed,
      metrics: current.metrics,
      alertType: current.alertType,
    ));
  }

  Future<void> endSession() async {
    await _stopTimer();
    await _repository.syncPendingLogsIfOnline();
    emit(const SessionEnded());
  }

  void acknowledgeAlert() {
    if (state is! SessionActive) return;

    _alertActive = false;

    final current = state as SessionActive;

    emit(current.copyWith(alertType: AlertType.none));
  }

  Future<void> _stopTimer() async {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() async {
    await _stopTimer();
    return super.close();
  }
}