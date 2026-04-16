import '../../../../core/network/api_consumer.dart';
import '../models/log_history_item_model.dart';
import '../models/log_history_session_details_model.dart';
import '../models/log_history_summary_model.dart';

class LogHistoryService {
  LogHistoryService(this._apiConsumer);

  // ignore: unused_field
  final ApiConsumer _apiConsumer;

  Future<LogHistorySummaryModel> fetchSummary() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return LogHistorySummaryModel.fromJson(_dummySummary);
  }

  Future<List<LogHistoryItemModel>> fetchHistory() async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    return _dummyHistory
        .map((item) => LogHistoryItemModel.fromJson(item))
        .toList(growable: false);
  }

  Future<LogHistorySessionDetailsModel> fetchSessionDetails({
    required String sessionId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    final details = _dummySessionDetails[sessionId] ?? _dummySessionDetails['s1'];
    return LogHistorySessionDetailsModel.fromJson(details!);
  }
}

const Map<String, dynamic> _dummySummary = <String, dynamic>{
  'safetyScore': 94,
  'safetyDelta': 2,
  'totalDrives': 28,
  'totalDrivesPeriodLabel': 'Weekly',
};

const List<Map<String, dynamic>> _dummyHistory = <Map<String, dynamic>>[
  <String, dynamic>{
    'id': 's1',
    'startedAtLabel': 'Oct 24, 2023 • 08:30 AM',
    'statusLabel': 'SAFE DRIVE',
    'durationLabel': '45 mins',
    'alertsDetected': 0,
    'statusColorHex': '#1DBE73',
  },
  <String, dynamic>{
    'id': 's2',
    'startedAtLabel': 'Oct 24, 2023 • 07:15 AM',
    'statusLabel': 'ATTENTION REQUIRED',
    'durationLabel': '15 mins',
    'alertsDetected': 3,
    'statusColorHex': '#F4B400',
  },
  <String, dynamic>{
    'id': 's3',
    'startedAtLabel': 'Oct 23, 2023 • 05:45 PM',
    'statusLabel': 'SAFE DRIVE',
    'durationLabel': '1h 12m',
    'alertsDetected': 0,
    'statusColorHex': '#1DBE73',
  },
  <String, dynamic>{
    'id': 's4',
    'startedAtLabel': 'Oct 23, 2023 • 08:20 AM',
    'statusLabel': 'DROWSINESS ALERT',
    'durationLabel': '32 mins',
    'alertsDetected': 1,
    'statusColorHex': '#F4B400',
  },
];

const Map<String, Map<String, dynamic>> _dummySessionDetails =
    <String, Map<String, dynamic>>{
  's1': <String, dynamic>{
    'sessionId': 's1',
    'sessionDateLabel': 'Oct 24, 2023',
    'sessionStartTimeLabel': '08:30 AM',
    'durationLabel': '45 min',
    'safetyScore': 82,
    'detectionsCount': 4,
    'timeline': <Map<String, dynamic>>[
      <String, dynamic>{
        'title': 'Session Started',
        'timeLabel': '08:30 AM',
        'description': '',
        'levelLabel': '',
        'eventType': 'start',
      },
      <String, dynamic>{
        'title': 'Yawn Detected',
        'timeLabel': '08:45 AM',
        'description': 'Minor fatigue signs',
        'levelLabel': 'LOW ALERT',
        'eventType': 'low',
      },
      <String, dynamic>{
        'title': 'Critical Drowsiness',
        'timeLabel': '09:12 AM',
        'description': 'Long eye closure duration',
        'levelLabel': 'HIGH RISK',
        'eventType': 'high',
        'previewImageUrl':
            'https://images.unsplash.com/photo-1493238792000-8113da705763?q=80&w=1200&auto=format&fit=crop',
      },
      <String, dynamic>{
        'title': 'Phone Usage Detected',
        'timeLabel': '09:18 AM',
        'description': '',
        'levelLabel': '',
        'eventType': 'phone',
      },
      <String, dynamic>{
        'title': 'Session Ended',
        'timeLabel': '09:30 AM',
        'description': '',
        'levelLabel': '',
        'eventType': 'end',
      },
    ],
  },
  's2': <String, dynamic>{
    'sessionId': 's2',
    'sessionDateLabel': 'Oct 24, 2023',
    'sessionStartTimeLabel': '07:15 AM',
    'durationLabel': '15 min',
    'safetyScore': 74,
    'detectionsCount': 3,
    'timeline': <Map<String, dynamic>>[
      <String, dynamic>{
        'title': 'Session Started',
        'timeLabel': '07:15 AM',
        'description': '',
        'levelLabel': '',
        'eventType': 'start',
      },
      <String, dynamic>{
        'title': 'Yawn Detected',
        'timeLabel': '07:20 AM',
        'description': 'Repeated yawning detected',
        'levelLabel': 'LOW ALERT',
        'eventType': 'low',
      },
      <String, dynamic>{
        'title': 'Phone Usage Detected',
        'timeLabel': '07:25 AM',
        'description': 'Eyes off road for multiple seconds',
        'levelLabel': 'HIGH RISK',
        'eventType': 'high',
      },
      <String, dynamic>{
        'title': 'Session Ended',
        'timeLabel': '07:30 AM',
        'description': '',
        'levelLabel': '',
        'eventType': 'end',
      },
    ],
  },
};
