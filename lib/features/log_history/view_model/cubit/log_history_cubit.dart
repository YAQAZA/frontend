import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/models/log_history_item_model.dart';
import '../../model/repositories/log_history_repository.dart';
import 'log_history_state.dart';

class LogHistoryCubit extends Cubit<LogHistoryState> {
  LogHistoryCubit(this._logHistoryRepository) : super(const LogHistoryInitial());

  final LogHistoryRepository _logHistoryRepository;

  Future<void> loadHistory() async {
    emit(const LogHistoryLoading());
    try {
      final summary = await _logHistoryRepository.fetchSummary();
      final logs = await _logHistoryRepository.fetchHistory();

      final todayLogs = <LogHistoryItemModel>[];
      final yesterdayLogs = <LogHistoryItemModel>[];
      for (final log in logs) {
        if (log.startedAtLabel.contains('Oct 24')) {
          todayLogs.add(log);
        } else {
          yesterdayLogs.add(log);
        }
      }

      emit(
        LogHistoryLoaded(
          summary: summary,
          todayLogs: todayLogs,
          yesterdayLogs: yesterdayLogs,
        ),
      );
    } catch (e) {
      emit(LogHistoryError(e.toString()));
    }
  }

  Future<void> loadSessionDetails({
    required String sessionId,
  }) async {
    emit(const LogHistoryDetailsLoading());
    try {
      final details = await _logHistoryRepository.fetchSessionDetails(
        sessionId: sessionId,
      );
      emit(LogHistoryDetailsLoaded(details));
    } catch (e) {
      emit(LogHistoryError(e.toString()));
    }
  }
}
