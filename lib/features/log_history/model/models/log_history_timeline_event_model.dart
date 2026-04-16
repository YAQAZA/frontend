import 'package:equatable/equatable.dart';

class LogHistoryTimelineEventModel extends Equatable {
  const LogHistoryTimelineEventModel({
    required this.title,
    required this.timeLabel,
    required this.description,
    required this.levelLabel,
    required this.eventType,
    this.previewImageUrl,
  });

  final String title;
  final String timeLabel;
  final String description;
  final String levelLabel;
  final String eventType;
  final String? previewImageUrl;

  factory LogHistoryTimelineEventModel.fromJson(Map<String, dynamic> json) {
    return LogHistoryTimelineEventModel(
      title: (json['title'] ?? '') as String,
      timeLabel: (json['timeLabel'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      levelLabel: (json['levelLabel'] ?? '') as String,
      eventType: (json['eventType'] ?? '') as String,
      previewImageUrl: json['previewImageUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        title,
        timeLabel,
        description,
        levelLabel,
        eventType,
        previewImageUrl,
      ];
}
