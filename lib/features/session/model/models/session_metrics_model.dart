class SessionMetricsModel {
  const SessionMetricsModel({
    required this.sleepinessProbability,
    required this.status,
    required this.riskLabel,
    required this.alertThreshold,
  });

  final int sleepinessProbability;
  final String status;
  final String riskLabel;
  final int alertThreshold;

  factory SessionMetricsModel.fromJson(Map<String, dynamic> json) {
    return SessionMetricsModel(
      sleepinessProbability: json['sleepinessProbability'] as int,
      status: json['status'] as String,
      riskLabel: json['riskLabel'] as String,
      alertThreshold: json['alertThreshold'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sleepinessProbability': sleepinessProbability,
      'status': status,
      'riskLabel': riskLabel,
      'alertThreshold': alertThreshold,
    };
  }
}

