import '../models/session_metrics_model.dart';
import '../models/session_event_log_model.dart';
import '../models/session_alert_type.dart';
import '../services/session_log_local_service.dart';
import '../services/session_log_remote_service.dart';
import '../services/session_service.dart';

class SessionRepository {
  SessionRepository(
    this._sessionService,
    this._sessionLogLocalService,
    this._sessionLogRemoteService,
  );

  final SessionService _sessionService;
  final SessionLogLocalService _sessionLogLocalService;
  final SessionLogRemoteService _sessionLogRemoteService;

  Future<SessionMetricsModel> getMetrics({
    required int tick,
  }) {
    return _sessionService.getMetrics(tick: tick);
  }

  Future<void> saveAlertLog({
    required String sessionId,
    required SessionAlertType alertType,
    required Duration elapsed,
    required int sleepinessProbability,
    required String statusLabel,
  }) async {
    final log = SessionEventLogModel(
      sessionId: sessionId,
      alertType: alertType,
      detectedAtIso: DateTime.now().toUtc().toIso8601String(),
      elapsedSeconds: elapsed.inSeconds,
      sleepinessProbability: sleepinessProbability,
      statusLabel: statusLabel,
      synced: false,
    );
    await _sessionLogLocalService.insertLog(log);
  }

  Future<void> syncPendingLogsIfOnline() async {
    final isOnline = await _sessionLogRemoteService.hasInternetConnection();
    if (!isOnline) return;

    final pending = await _sessionLogLocalService.getPendingLogs();
    if (pending.isEmpty) return;

    await _sessionLogRemoteService.syncToMainDatabase(pending);
    final ids = pending
        .map((log) => log.id)
        .whereType<int>()
        .toList(growable: false);
    await _sessionLogLocalService.markLogsAsSynced(ids);
  }
}

