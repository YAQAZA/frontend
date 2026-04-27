import '../../../../core/constants/constants.dart';
import '../models/alert_type.dart';
import '../models/detection_result.dart';
import '../models/session_metrics_model.dart';
import 'detection_service.dart';
import '../models/risk_type.dart';

class SessionService {
  final DetectionService _detectionService;

  SessionService(this._detectionService);

  Future<SessionMetricsModel> getMetrics({required int tick}) async {
    final result = await _detectionService.detect();

    final alertType = _detectAlert(result);
    final description = _getDescription(alertType, result);

    return SessionMetricsModel(
      sleepinessProbability: result.sleepiness,
      alert: alertType,
      status: result.status,
      risk: _mapRisk(result.risk),
      isYawning: result.isYawning,
      isLookingAway: result.isLookingAway,
      detectedObject: result.object,
      imageURL: result.imageURL,
      description: description,
    );
  }

  AlertType _detectAlert(DetectionResult result) {
    if (result.sleepiness >= DummyData.alertThreshold) {
      return AlertType.drowsiness;
    } else if (result.isYawning) {
      return AlertType.yawning;
    } else if (result.isLookingAway) {
      return AlertType.distraction;
    } else if (result.object != null) {
      return AlertType.object;
    }

    return AlertType.none;
  }

  String _getDescription(AlertType type, DetectionResult result) {
    String description = AppStrings.alertDescription[type]!;

    if (type == AlertType.object && result.object != null) {
      description += result.object!;
    }

    return description;
  }

  RiskType _mapRisk(String risk) {
    return RiskType.values.firstWhere(
      (e) => e.toString() == risk,
      orElse: () => RiskType.low,
    );
  }
}
