import '../models/log_history_item_model.dart';
import '../models/log_history_session_details_model.dart';
import '../models/log_history_summary_model.dart';
import '../services/log_history_service.dart';

class LogHistoryRepository {
  LogHistoryRepository(this._logHistoryService);

  final LogHistoryService _logHistoryService;

  Future<LogHistorySummaryModel> fetchSummary() {
    return _logHistoryService.fetchSummary();
  }

  Future<List<LogHistoryItemModel>> fetchHistory() {
    return _logHistoryService.fetchHistory();
  }

  Future<LogHistorySessionDetailsModel> fetchSessionDetails({
    required String sessionId,
  }) {
    return _logHistoryService.fetchSessionDetails(sessionId: sessionId);
  }
}
