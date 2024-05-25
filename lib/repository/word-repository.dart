import '../db/db.dart';

class WordRepository {
  final DatabaseHelper _databaseHelper;

  WordRepository(this._databaseHelper);

  Future<List<Map<String, dynamic>>> getWordsByCategory(String category) async {
    final db = await _databaseHelper.database;
    final result = await db.query('words', where: 'category = ?', whereArgs: [category]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllWords() async {
    final db = await _databaseHelper.database;
    final result = await db.query('words');
    return result;
  }
}