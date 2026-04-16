import 'package:equatable/equatable.dart';

import 'log_history_timeline_event_model.dart';

class LogHistorySessionDetailsModel extends Equatable {
  const LogHistorySessionDetailsModel({
    required this.sessionId,
    required this.sessionDateLabel,
    required this.sessionStartTimeLabel,
    required this.durationLabel,
    required this.safetyScore,
    required this.detectionsCount,
    required this.timeline,
  });

  final String sessionId;
  final String sessionDateLabel;
  final String sessionStartTimeLabel;
  final String durationLabel;
  final int safetyScore;
  final int detectionsCount;
  final List<LogHistoryTimelineEventModel> timeline;

  factory LogHistorySessionDetailsModel.fromJson(Map<String, dynamic> json) {
    return LogHistorySessionDetailsModel(
      sessionId: (json['sessionId'] ?? '') as String,
      sessionDateLabel: (json['sessionDateLabel'] ?? '') as String,
      sessionStartTimeLabel: (json['sessionStartTimeLabel'] ?? '') as String,
      durationLabel: (json['durationLabel'] ?? '') as String,
      safetyScore: (json['safetyScore'] ?? 0) as int,
      detectionsCount: (json['detectionsCount'] ?? 0) as int,
      timeline: ((json['timeline'] ?? const <dynamic>[]) as List<dynamic>)
          .map(
            (event) => LogHistoryTimelineEventModel.fromJson(
              Map<String, dynamic>.from(event as Map),
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        sessionDateLabel,
        sessionStartTimeLabel,
        durationLabel,
        safetyScore,
        detectionsCount,
        timeline,
      ];
}
