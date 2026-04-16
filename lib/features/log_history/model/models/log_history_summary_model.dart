import 'package:equatable/equatable.dart';

class LogHistorySummaryModel extends Equatable {
  const LogHistorySummaryModel({
    required this.safetyScore,
    required this.safetyDelta,
    required this.totalDrives,
    required this.totalDrivesPeriodLabel,
  });

  final int safetyScore;
  final int safetyDelta;
  final int totalDrives;
  final String totalDrivesPeriodLabel;

  factory LogHistorySummaryModel.fromJson(Map<String, dynamic> json) {
    return LogHistorySummaryModel(
      safetyScore: (json['safetyScore'] ?? 0) as int,
      safetyDelta: (json['safetyDelta'] ?? 0) as int,
      totalDrives: (json['totalDrives'] ?? 0) as int,
      totalDrivesPeriodLabel: (json['totalDrivesPeriodLabel'] ?? '') as String,
    );
  }

  @override
  List<Object?> get props => [
        safetyScore,
        safetyDelta,
        totalDrives,
        totalDrivesPeriodLabel,
      ];
}
