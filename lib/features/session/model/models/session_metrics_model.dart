import 'alert_type.dart';
import 'risk_type.dart';

class SessionMetricsModel {
  const SessionMetricsModel({
    required this.sleepinessProbability,
    required this.alert,
    required this.status,
    required this.risk,
    this.isYawning,
    this.isLookingAway,
    this.detectedObject,
    required this.imageURL,
    required this.description
  });

  final int sleepinessProbability;
  final AlertType alert;
  final String status;
  final RiskType risk;
  final bool? isYawning;
  final bool? isLookingAway;
  final String? detectedObject;
  final String imageURL;
  final String description;

  factory SessionMetricsModel.fromJson(Map<String, dynamic> json) {
    return SessionMetricsModel(
      sleepinessProbability: json['sleepinessProbability'] as int,
      alert: AlertType.values.firstWhere(
        (e) => e.toString() == json['alert'],
        orElse: () => AlertType.none,
      ),
      status: json['status'] as String,
      risk: RiskType.values.firstWhere(
        (element) => element.toString() == json['risk'],
        orElse: () => RiskType.low,
      ),
      isYawning: json['isYawning'] as bool?,
      isLookingAway: json['isLookingAway'] as bool?,
      detectedObject: json['detectedObject'] as String?,
      imageURL: json['imageURL'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sleepinessProbability': sleepinessProbability,
      'alert': alert.toString(),
      'status': status,
      'risk': risk.toString(),
      'isYawning': isYawning,
      'isLookingAway': isLookingAway,
      'detectedObject': detectedObject,
      'imageURL': imageURL,
      'description': description,
    };
  }


  SessionMetricsModel copyWith({
    int? sleepinessProbability,
    AlertType? alert,
    String? status,
    RiskType? risk,
    bool? isYawning,
    bool? isLookingAway,
    String? detectedObject,
    String? imageURL,
    String? description,
  }) {
    return SessionMetricsModel(
      sleepinessProbability:
          sleepinessProbability ?? this.sleepinessProbability,
      alert: alert ?? this.alert,
      status: status ?? this.status,
      risk: risk ?? this.risk,
      isYawning: isYawning ?? this.isYawning,
      isLookingAway: isLookingAway ?? this.isLookingAway,
      detectedObject: detectedObject ?? this.detectedObject,
      imageURL: imageURL ?? this.imageURL,
      description: description ?? this.description,
    );
  }
}