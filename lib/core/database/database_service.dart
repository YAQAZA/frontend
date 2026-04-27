abstract class DatabaseService {
  Future<int> insert({
    required String table,
    required Map<String, dynamic> data,
  });

  Future<int> update({
    required String table,
    required Map<String, dynamic> data,
    required String where,
    required List<Object?> whereArgs,
  });

  Future<int> delete({
    required String table,
    required String where,
    required List<Object?> whereArgs,
  });

  Future<List<Map<String, dynamic>>> query({
    required String table,
    String? where,
    List<Object?>? whereArgs,
  });
}