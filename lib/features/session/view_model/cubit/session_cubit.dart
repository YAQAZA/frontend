import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/models/alert_type.dart';
import '../../model/models/session_metrics_model.dart';
import '../../model/repositories/session_repository.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._repository) : super(const SessionInitial());

  final SessionRepository _repository;

  Timer? _timer;
  int _tick = 0;
  String _sessionId = '';
  DateTime? _startTime;

  bool _isProcessing = false;
  AlertType _lastAlert = AlertType.none;

  // =========================
  // START SESSION
  // =========================
Future<void> startSession() async {
  await _stopTimer();

  _tick = 0;
  _startTime = DateTime.now();
  _lastAlert = AlertType.none;
  _sessionId = DateTime.now().millisecondsSinceEpoch.toString();

  emit(const SessionStarting());

  emit(SessionActive(
    elapsed: Duration.zero,
    metrics: null,
    alertType: AlertType.none,
  ));

  _startTimer();
}

Future<void> updateMetrics(CameraImage image) async {
  if (state is! SessionActive) return;
  if (_isProcessing) return;
  _isProcessing = true;

  try {
    final current = state as SessionActive;

    final metrics = await _repository.getMetrics(tick: _tick, image: image);

    if (metrics.alert != AlertType.none && metrics.alert != _lastAlert) {
      _lastAlert = metrics.alert;

      await _repository.saveAlertLog(
        sessionId: _sessionId,
        alertType: metrics.alert,
        sleepinessProbability: metrics.sleepinessProbability,
        severity: metrics.status,
        description: metrics.description,
        imageURL: metrics.imageURL,
      );
    }

    emit(current.copyWith(
      metrics: metrics,
      alertType: metrics.alert,
    ));
  } finally {
    _isProcessing = false;
  }
}

  // =========================
  void resumeSession() {
    final current = state;
    if (current is! SessionPaused) return;

    _tick = current.elapsed.inSeconds;
    _startTime = DateTime.now().subtract(current.elapsed);


    emit(SessionActive(
      elapsed: current.elapsed,
      metrics: current.metrics,
      alertType: AlertType.none,
    ));

    _startTimer();
  }

  // =========================
  // TIMER HANDLING
  void _startTimer() {
    if (_timer != null) return; 
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _onTick();
    });
  }

 Future<void> _onTick() async {
  if (isClosed || _startTime == null) return;

  final elapsed = DateTime.now().difference(_startTime!);
  _tick = elapsed.inSeconds;

  final current = state;

  if (current is SessionActive) {
    emit(current.copyWith(
      elapsed: elapsed,
      alertType: current.alertType,
    ));
    await _repository.syncPendingLogsIfOnline();
  }
}

  // =========================
  // PAUSE SESSION
  Future<void> pauseSession() async {
    final current = state;
    if (current is! SessionActive) return;

    await _stopTimer();

    emit(SessionPaused(
      elapsed: current.elapsed,
      metrics: current.metrics!,
      alertType: current.alertType,
    ));
  }

  // =========================
  // END SESSION
  Future<void> endSession() async {
    await _stopTimer();
    await _repository.syncPendingLogsIfOnline();

    emit(const SessionEnded());
  }

  // =========================
  // ALERT ACKNOWLEDGE
  void acknowledgeAlert() {
    if (state is! SessionActive) return;

    final current = state as SessionActive;

    emit(current.copyWith(alertType: AlertType.none));
  }

  // =========================
  // STOP TIMER
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