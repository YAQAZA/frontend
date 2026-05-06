import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_logger.dart';
import '../../model/models/alert_type.dart';
import '../../model/repositories/session_repository.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._repository) : super(const SessionInitial());

  final SessionRepository _repository;

  Timer? _timer;
  int _tick = 0;
  String _sessionId = '';
  DateTime? _startTime;
  bool _started = false;

  bool _isProcessing = false;
  AlertType _lastAlert = AlertType.none;

  // =========================
  // START SESSION
  // =========================
  void initSession() {
    emit(const SessionStarting());
  }

  Future<void> startSession(CameraImage firstFrame) async {
    AppLogger.logger.w('/#################START SESSION##################');

    try {
      _repository.loadModel();
    } catch (e) {
      AppLogger.logger.e(
        '#################################################Error loading model: $e',
      );
    }

    _tick = 0;
    _startTime = DateTime.now();
    _isProcessing = true;


    final metrics = await _repository.getMetrics(tick: 0, image: firstFrame);

    emit(
      SessionActive(
        elapsed: Duration.zero,
        metrics: metrics,
        alertType: AlertType.none,
      ),
    );

    _startTimer();
  }

  Future<void> updateMetrics(CameraImage image) async {
    if (!_started) {
      _started = true;
      await startSession(image);
      return;
    }

    if (!_isProcessing || state is! SessionActive) return;
    AppLogger.logger.w('/#################UPDATE METRICS##################');

    try {
      final current = state as SessionActive;

      final metrics = await _repository.getMetrics(tick: _tick, image: image);

      if (metrics.alert != AlertType.none && metrics.alert != _lastAlert) {
        _lastAlert = metrics.alert;

        await _repository.saveAlertLog(
          sessionId: _sessionId,
          alertType: metrics.alert,
          elapsed: current.elapsed,
          sleepinessProbability: metrics.sleepinessProbability,
          severity: metrics.status,
          description: metrics.description,
          imageURL: metrics.imageURL,
        );
      }

      emit(current.copyWith(metrics: metrics, alertType: metrics.alert));
    } catch (e) {
      AppLogger.logger.e(
        '#################################################Error updating metrics: $e',
      );
    }
  }

  // =========================
  void resumeSession() {
    final current = state;
    if (current is! SessionPaused) return;

    _tick = current.elapsed.inSeconds;
    _startTime = DateTime.now().subtract(current.elapsed);

    emit(
      SessionActive(
        elapsed: current.elapsed,
        metrics: current.metrics,
        alertType: AlertType.none,
      ),
    );

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
      emit(current.copyWith(elapsed: elapsed, alertType: AlertType.none));
    }
  }

  // =========================
  // PAUSE SESSION
  Future<void> pauseSession() async {
    final current = state;
    if (current is! SessionActive) return;

    await _stopTimer();

    emit(
      SessionPaused(
        elapsed: current.elapsed,
        metrics: current.metrics,
        alertType: current.alertType,
      ),
    );
  }

  // =========================
  // END SESSION
  Future<void> endSession() async {
    _isProcessing = false;
    await _stopTimer();
    _started = false;
    AppLogger.logger.w('/#################END SESSION##################');

    // await _repository.syncPendingLogsIfOnline();

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

  get isProcessing => _isProcessing;
  set isProcessing(bool value) => _isProcessing = value;
}
