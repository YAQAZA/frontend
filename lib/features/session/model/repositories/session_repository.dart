import 'package:camera/camera.dart';

import '../models/session_metrics_model.dart';
import '../models/detection_log_model.dart';
import '../models/alert_type.dart';
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
    required CameraImage image,
  }) {
    return _sessionService.getMetrics(tick: tick, image: image);
  }

  Future<void> saveAlertLog({
    required String sessionId,
    required AlertType alertType,
    required Duration elapsed,
    required int sleepinessProbability,
    required String severity,
    required String imageURL,
    required String description,
  }) async {
    final log = DetectionLogModel(
      sessionId: sessionId,
      alertType: alertType,
      timestamp: DateTime.now().toUtc().toIso8601String(),
      sleepinessProbability: sleepinessProbability,
      severity: severity,
      description: description,
      imageURL: imageURL
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

  void loadModel(){
      _sessionService.loadModel();
  }
}

