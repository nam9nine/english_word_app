
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('words.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    await deleteDatabase(path);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE words (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      english TEXT NOT NULL,
      meaning TEXT,
      category TEXT NOT NULL,
      is_wrong INTEGER NOT NULL DEFAULT 0
    )
  ''');
    await _insertInitialWords(db);
  }

  Future _insertInitialWords(Database db) async {
    try {
      String data = await rootBundle.loadString('assets/data/words.json');
      List<dynamic> words = jsonDecode(data);
      for (var word in words) {
        await db.insert('words', word);
      }
    } catch (e) {
      print('데이터베이스 <- 단어 입력 오류 word : $e');
    }
  }

}