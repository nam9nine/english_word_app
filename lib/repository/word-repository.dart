import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../db/db.dart';
import '../model/category-word.model.dart';

class WordRepository {
  final DatabaseHelper _databaseHelper;

  WordRepository(this._databaseHelper);

  Future<List<Word>> getWordsByCategory(String category) async {
    final db = await _databaseHelper.database;
    final result = await db.query('words', where: 'category = ?', whereArgs: [category]);
    List<Word> words = result.map((map) => Word.fromMap(map)).toList();
    return words;
  }

  Future<List<Map<String, dynamic>>> getAllWords() async {
    final db = await _databaseHelper.database;
    final result = await db.query('words');
    return result;
  }

  Future<void> deleteDatabaseFile() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'words.db');
    await deleteDatabase(path);
  }
}