import 'package:equatable/equatable.dart';

import 'session_alert_type.dart';

class SessionEventLogModel extends Equatable {
  const SessionEventLogModel({
    this.id,
    required this.sessionId,
    required this.alertType,
    required this.detectedAtIso,
    required this.elapsedSeconds,
    required this.sleepinessProbability,
    required this.statusLabel,
    this.synced = false,
  });

  final int? id;
  final String sessionId;
  final SessionAlertType alertType;
  final String detectedAtIso;
  final int elapsedSeconds;
  final int sleepinessProbability;
  final String statusLabel;
  final bool synced;

  Map<String, dynamic> toSqlMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'session_id': sessionId,
      'alert_type': alertType.name,
      'detected_at_iso': detectedAtIso,
      'elapsed_seconds': elapsedSeconds,
      'sleepiness_probability': sleepinessProbability,
      'status_label': statusLabel,
      'synced': synced ? 1 : 0,
    };
  }

  Map<String, dynamic> toApiMap() {
    return <String, dynamic>{
      'localId': id,
      'sessionId': sessionId,
      'alertType': alertType.name,
      'detectedAt': detectedAtIso,
      'elapsedSeconds': elapsedSeconds,
      'sleepinessProbability': sleepinessProbability,
      'status': statusLabel,
    };
  }

  factory SessionEventLogModel.fromSqlMap(Map<String, dynamic> map) {
    final alertTypeName = map['alert_type'] as String? ?? SessionAlertType.none.name;
    return SessionEventLogModel(
      id: map['id'] as int?,
      sessionId: map['session_id'] as String? ?? '',
      alertType: SessionAlertType.values.firstWhere(
        (value) => value.name == alertTypeName,
        orElse: () => SessionAlertType.none,
      ),
      detectedAtIso: map['detected_at_iso'] as String? ?? '',
      elapsedSeconds: map['elapsed_seconds'] as int? ?? 0,
      sleepinessProbability: map['sleepiness_probability'] as int? ?? 0,
      statusLabel: map['status_label'] as String? ?? '',
      synced: (map['synced'] as int? ?? 0) == 1,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sessionId,
        alertType,
        detectedAtIso,
        elapsedSeconds,
        sleepinessProbability,
        statusLabel,
        synced,
      ];
}
