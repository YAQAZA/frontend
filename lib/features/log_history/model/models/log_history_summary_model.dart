import 'package:equatable/equatable.dart';

class LogHistorySummaryModel extends Equatable {
  const LogHistorySummaryModel({
    required this.safetyScore,
    required this.safetyDelta,
    required this.totalDrives,
  });

  final int safetyScore;
  final int safetyDelta;
  final int totalDrives;

  factory LogHistorySummaryModel.fromJson(Map<String, dynamic> json) {
    return LogHistorySummaryModel(
      safetyScore: (json['safetyScore'] ?? 0) as int,
      safetyDelta: (json['safetyDelta'] ?? 0) as int,
      totalDrives: (json['totalDrives'] ?? 0) as int,
    );
  }

  @override
  List<Object?> get props => [
        safetyScore,
        safetyDelta,
        totalDrives,
      ];
}
