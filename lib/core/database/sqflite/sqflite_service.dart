import 'package:sqflite/sqflite.dart';

import '../database_service.dart';

class SqfliteService implements DatabaseService {
  final Future<Database> db;

  SqfliteService(this.db);

  @override
  Future<int> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    final database = await db;
    return database.insert(table, data);
  }

  @override
  Future<int> update({
    required String table,
    required Map<String, dynamic> data,
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final database = await db;
    return database.update(table, data, where: where, whereArgs: whereArgs);
  }

  @override
  Future<int> delete({
    required String table,
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final database = await db;
    return database.delete(table, where: where, whereArgs: whereArgs);
  }

  @override
  Future<List<Map<String, dynamic>>> query({
    required String table,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final database = await db;
    return database.query(table, where: where, whereArgs: whereArgs);
  }
}