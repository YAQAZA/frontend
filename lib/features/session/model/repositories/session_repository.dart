
import '../models/session_metrics_model.dart';
import '../services/session_service.dart';

class SessionRepository {
  SessionRepository(this._sessionService);

  final SessionService _sessionService;

  Future<SessionMetricsModel> getMetrics({
    required int tick,
  }) {
    return _sessionService.getMetrics(tick: tick);
  }
}

