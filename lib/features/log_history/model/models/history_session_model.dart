import 'package:equatable/equatable.dart';

class HistorySessionModel extends Equatable {
  const HistorySessionModel({
    required this.id,
    required this.startedAtLabel,
    required this.statusLabel,
    required this.durationLabel,
    required this.alertsDetected,
  });

  final String id;
  final String startedAtLabel;
  final String statusLabel;
  final String durationLabel;
  final int alertsDetected;

  factory HistorySessionModel.fromJson(Map<String, dynamic> json) {
    return HistorySessionModel(
      id: (json['id'] ?? '') as String,
      startedAtLabel: (json['startedAtLabel'] ?? '') as String,
      statusLabel: (json['statusLabel'] ?? '') as String,
      durationLabel: (json['durationLabel'] ?? '') as String,
      alertsDetected: (json['alertsDetected'] ?? 0) as int,
    );
  }

  @override
  List<Object?> get props => [
        id,
        startedAtLabel,
        statusLabel,
        durationLabel,
        alertsDetected,
      ];
}
