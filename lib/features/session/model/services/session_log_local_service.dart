import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/detection_log_model.dart';

class SessionLogLocalService {
  SessionLogLocalService();

  static const String _databaseName = 'yaqazah_logs.db';
  static const int _databaseVersion = 2;
  static const String _tableName = 'session_alert_logs';

  Database? _database;

  Future<Database> _db() async {
    if (_database != null) {
      return _database!;
    }
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, _databaseName);
    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await _createLogsTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS $_tableName');
        await _createLogsTable(db);
      },
    );
    return _database!;
  }

  Future<void> _createLogsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id TEXT NOT NULL,
        alert_type TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        sleepiness_probability INTEGER NOT NULL,
        severity TEXT NOT NULL,
        description TEXT NOT NULL,
        image_url TEXT NOT NULL,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> insertLog(DetectionLogModel log) async {
    final db = await _db();
    await db.insert(_tableName, log.toSqlMap());
  }

  Future<List<DetectionLogModel>> getPendingLogs() async {
    final db = await _db();
    final rows = await db.query(
      _tableName,
      where: 'synced = ?',
      whereArgs: [0],
      orderBy: 'id ASC',
    );
    return rows
        .map((row) => DetectionLogModel.fromSqlMap(row))
        .toList(growable: false);
  }

  Future<void> markLogsAsSynced(List<int> ids) async {
    if (ids.isEmpty) return;
    final db = await _db();
    final placeholders = List<String>.filled(ids.length, '?').join(',');
    await db.rawUpdate(
      'UPDATE $_tableName SET synced = 1 WHERE id IN ($placeholders)',
      ids,
    );
  }
}
