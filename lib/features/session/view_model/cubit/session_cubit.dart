import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../model/models/session_alert_type.dart';
import '../../model/models/session_metrics_model.dart';
import '../../model/repositories/session_repository.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._sessionRepository) : super(const SessionInitial());

  final SessionRepository _sessionRepository;

  Timer? _timer;
  int _tick = 0;
  int _remindCount = 3;
  bool _alertActive = false;
  String _sessionId = '';

  Future<void> startSession() async {
    await _stopTimer();
    _tick = 0;
    _remindCount = 3;
    _alertActive = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();

    emit(const SessionStarting());

    // Emit first metrics quickly.
    final metrics = await _sessionRepository.getMetrics(tick: _tick);
    emit(
      SessionActive(
        elapsed: const Duration(seconds: 0),
        metrics: metrics,
        alertType: SessionAlertType.none,
        remindCount: _remindCount,
        threshold: metrics.alertThreshold,
      ),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      _tick++;

      final nextMetrics = await _sessionRepository.getMetrics(tick: _tick);
      final elapsed = Duration(seconds: _tick);
      await _sessionRepository.syncPendingLogsIfOnline();

      final shouldAlert = nextMetrics.sleepinessProbability >=
          nextMetrics.alertThreshold;

      if (shouldAlert && !_alertActive) {
        _alertActive = true;
        await _sessionRepository.saveAlertLog(
          sessionId: _sessionId,
          alertType: SessionAlertType.drowsiness,
          elapsed: elapsed,
          sleepinessProbability: nextMetrics.sleepinessProbability,
          statusLabel: nextMetrics.status,
        );
        emit(
          SessionActive(
            elapsed: elapsed,
            metrics: nextMetrics,
            alertType: SessionAlertType.drowsiness,
            remindCount: _remindCount,
            threshold: nextMetrics.alertThreshold,
          ),
        );
        return;
      }

      // Optional: occasionally trigger distraction.
      final isDistractionTick = _tick % 37 == 0;
      if (isDistractionTick && !_alertActive) {
        _alertActive = true;
        await _sessionRepository.saveAlertLog(
          sessionId: _sessionId,
          alertType: SessionAlertType.distraction,
          elapsed: elapsed,
          sleepinessProbability: nextMetrics.sleepinessProbability,
          statusLabel: nextMetrics.status,
        );
        emit(
          SessionActive(
            elapsed: elapsed,
            metrics: nextMetrics,
            alertType: SessionAlertType.distraction,
            remindCount: _remindCount,
            threshold: nextMetrics.alertThreshold,
          ),
        );
        return;
      }

      emit(
        SessionActive(
          elapsed: elapsed,
          metrics: nextMetrics,
          alertType: SessionAlertType.none,
          remindCount: _remindCount,
          threshold: nextMetrics.alertThreshold,
        ),
      );
    });
  }

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

  Future<void> endSession() async {
    await _stopTimer();
    await _sessionRepository.syncPendingLogsIfOnline();
    emit(const SessionEnded());
  }

  void remindAlert() {
    if (state is! SessionActive) return;
    if (_remindCount <= 0) return;
    _remindCount--;
    _alertActive = false;
    final current = state as SessionActive;
    emit(
      SessionActive(
        elapsed: current.elapsed,
        metrics: current.metrics,
        alertType: SessionAlertType.none,
        remindCount: _remindCount,
        threshold: current.threshold,
      ),
    );
  }

  void acknowledgeAlert() {
    if (state is! SessionActive) return;
    _remindCount = 3;
    _alertActive = false;
    final current = state as SessionActive;

    emit(
      SessionActive(
        elapsed: current.elapsed,
        metrics: SessionMetricsModel(
          sleepinessProbability: 40,
          status: AppStrings.statusNormal,
          riskLabel: AppStrings.lowRisk,
          alertThreshold: current.threshold,
        ),
        alertType: SessionAlertType.none,
        remindCount: _remindCount,
        threshold: current.threshold,
      ),
    );
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

