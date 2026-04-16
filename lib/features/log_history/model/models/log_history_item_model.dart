import 'package:equatable/equatable.dart';

class LogHistoryItemModel extends Equatable {
  const LogHistoryItemModel({
    required this.id,
    required this.startedAtLabel,
    required this.statusLabel,
    required this.durationLabel,
    required this.alertsDetected,
    required this.statusColorHex,
  });

  final String id;
  final String startedAtLabel;
  final String statusLabel;
  final String durationLabel;
  final int alertsDetected;
  final String statusColorHex;

  factory LogHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return LogHistoryItemModel(
      id: (json['id'] ?? '') as String,
      startedAtLabel: (json['startedAtLabel'] ?? '') as String,
      statusLabel: (json['statusLabel'] ?? '') as String,
      durationLabel: (json['durationLabel'] ?? '') as String,
      alertsDetected: (json['alertsDetected'] ?? 0) as int,
      statusColorHex: (json['statusColorHex'] ?? '#4CAF50') as String,
    );
  }

  @override
  List<Object?> get props => [
        id,
        startedAtLabel,
        statusLabel,
        durationLabel,
        alertsDetected,
        statusColorHex,
      ];
}
