import 'package:equatable/equatable.dart';
import '../../model/models/alert_type.dart';
import '../../model/models/session_metrics_model.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

final class SessionInitial extends SessionState {
  const SessionInitial();
}

final class SessionStarting extends SessionState {
  const SessionStarting();
}

final class SessionActive extends SessionState {
  const SessionActive({
    required this.elapsed,
    required this.metrics,
    required this.alertType,
  });

  final Duration elapsed;
  final SessionMetricsModel metrics;
  final AlertType alertType;

  SessionActive copyWith({
    Duration? elapsed,
    SessionMetricsModel? metrics,
    AlertType? alertType,
  }) {
    return SessionActive(
      elapsed: elapsed ?? this.elapsed,
      metrics: metrics ?? this.metrics,
      alertType: alertType ?? this.alertType,
    );
  }

  @override
  List<Object?> get props => [elapsed, metrics, alertType];
}

final class SessionPaused extends SessionState {
  const SessionPaused({
    required this.elapsed,
    required this.metrics,
    required this.alertType,
  });

  final Duration elapsed;
  final SessionMetricsModel metrics;
  final AlertType alertType;

  @override
  List<Object?> get props => [elapsed, metrics, alertType];
}

final class SessionEnded extends SessionState {
  const SessionEnded();
}