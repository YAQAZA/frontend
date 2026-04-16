import '../../../../core/constants/constants.dart';
import '../../../../core/network/api_consumer.dart';
import '../models/session_metrics_model.dart';

/// Dummy service for session metrics.
/// Keeps ApiConsumer wiring ready for backend integration.
class SessionService {
  SessionService(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<SessionMetricsModel> getMetrics({
    required int tick,
  }) async {
    // Dummy delay to mimic async work.
    await Future<void>.delayed(const Duration(milliseconds: 50));

    // Create deterministic-ish values based on tick.
    final probability = () {
      final base = 12 + (tick % 10) * 8; // 12..84
      final bump = tick % 24 < 6 ? 18 : 0; // occasionally push above threshold
      return (base + bump).clamp(0, 100);
    }();

    final status = probability >= 85
        ? AppStrings.statusSleepy
        : probability >= 55
            ? AppStrings.statusDrowsy
            : AppStrings.statusNormal;

    final riskLabel = probability >= 75 ? AppStrings.highRisk : AppStrings.lowRisk;

    // For now threshold is fixed to match UI design.
    const threshold = 75;

    return SessionMetricsModel(
      sleepinessProbability: probability,
      status: status,
      riskLabel: riskLabel,
      alertThreshold: threshold,
    );
  }
}

