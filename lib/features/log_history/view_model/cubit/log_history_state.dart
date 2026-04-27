import 'package:equatable/equatable.dart';

import '../../model/models/history_session_model.dart';
import '../../model/models/log_history_session_details_model.dart';
import '../../model/models/log_history_summary_model.dart';

sealed class LogHistoryState extends Equatable {
  const LogHistoryState();

  @override
  List<Object?> get props => [];
}

final class LogHistoryInitial extends LogHistoryState {
  const LogHistoryInitial();
}

final class LogHistoryLoading extends LogHistoryState {
  const LogHistoryLoading();
}

final class LogHistoryLoaded extends LogHistoryState {
  const LogHistoryLoaded({
    required this.summary,
    required this.todayLogs,
    required this.yesterdayLogs,
  });

  final LogHistorySummaryModel summary;
  final List<HistorySessionModel> todayLogs;
  final List<HistorySessionModel> yesterdayLogs;

  @override
  List<Object?> get props => [summary, todayLogs, yesterdayLogs];
}

final class LogHistoryDetailsLoading extends LogHistoryState {
  const LogHistoryDetailsLoading();
}

final class LogHistoryDetailsLoaded extends LogHistoryState {
  const LogHistoryDetailsLoaded(this.details);

  final LogHistorySessionDetailsModel details;

  @override
  List<Object?> get props => [details];
}

final class LogHistoryError extends LogHistoryState {
  const LogHistoryError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
