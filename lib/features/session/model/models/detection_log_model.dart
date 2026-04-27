import 'package:equatable/equatable.dart';

import 'alert_type.dart';

class DetectionLogModel extends Equatable {
  const DetectionLogModel({
    this.id,
    required this.sessionId,
    required this.alertType,
    required this.timestamp,
    required this.sleepinessProbability,
    required this.severity,
    required this.description,
    required this.imageURL
  });

  final int? id;
  final String sessionId;
  final AlertType alertType;
  final String timestamp;
  final int sleepinessProbability;
  final String severity;
  final String description;
  final String imageURL;

  Map<String, dynamic> toSqlMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'session_id': sessionId,
      'alert_type': alertType.name,
      'timestamp': timestamp,
      'sleepiness_probability': sleepinessProbability,
      'severity': severity,
      'description': description,
      'image_url': imageURL,
    };
  }

  Map<String, dynamic> toApiMap() {
    return <String, dynamic>{
      'localId': id,
      'sessionId': sessionId,
      'alertType': alertType.name,
      'timestamp': timestamp,
      'sleepinessProbability': sleepinessProbability,
      'severity': severity,
      'description': description,
      'imageURL': imageURL,
    };
  }

  factory DetectionLogModel.fromSqlMap(Map<String, dynamic> map) {
    final alertTypeName = map['alert_type'] as String? ?? AlertType.none.name;
    return DetectionLogModel(
      id: map['id'] as int?,
      sessionId: map['session_id'] as String? ?? '',
      alertType: AlertType.values.firstWhere(
        (value) => value.name == alertTypeName,
        orElse: () => AlertType.none,
      ),
      timestamp: map['timestamp'] as String? ?? '',
      sleepinessProbability: map['sleepiness_probability'] as int? ?? 0,
      severity: map['severity'] as String? ?? '',
      description: map['description'] as String? ?? '',
      imageURL: map['image_url'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        sessionId,
        alertType,
        timestamp,
        sleepinessProbability,
        severity,
        description,
        imageURL
      ];
}
