import 'dart:io';

import '../../../../core/network/api_consumer.dart';
import '../models/session_event_log_model.dart';

class SessionLogRemoteService {
  SessionLogRemoteService(this._apiConsumer);

  // ignore: unused_field
  final ApiConsumer _apiConsumer;

  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  Future<void> syncToMainDatabase(List<SessionEventLogModel> logs) async {
    if (logs.isEmpty) return;

    // Dummy sync payload for backend endpoint that persists into PostgreSQL.
    // Replace with real API path when backend endpoint is available.
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
