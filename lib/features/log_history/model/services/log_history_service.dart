import 'package:yaqazah/core/ui.dart';

import '../../../../core/network/api_consumer.dart';
import '../models/history_session_model.dart';
import '../models/log_history_session_details_model.dart';
import '../models/log_history_summary_model.dart';

class LogHistoryService {
  LogHistoryService(this._apiConsumer);

  // ignore: unused_field
  final ApiConsumer _apiConsumer;

  Future<LogHistorySummaryModel> fetchSummary() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return LogHistorySummaryModel.fromJson(DummyData.dummySummary);
  }

  Future<List<HistorySessionModel>> fetchHistory() async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    return DummyData.dummyHistory
        .map((item) => HistorySessionModel.fromJson(item))
        .toList(growable: false);
  }

  Future<LogHistorySessionDetailsModel> fetchSessionDetails({
    required String sessionId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));
    final details = DummyData.dummySessionDetails[sessionId] ?? DummyData.dummySessionDetails['s1'];
    return LogHistorySessionDetailsModel.fromJson(details!);
  }
}
