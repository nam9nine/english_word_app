
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // 데이터 베이스 초기 설정
    _database = await _initDB('words.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // 데이터베이스 데이터를 모두 지움
    await deleteDatabase(path);
    // 데이터베이스 생성 될 때 _createDB 호출
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }
  Future<void> _createDB(Database db, int version) async {
    //테이블 정의
    await db.execute('''
    CREATE TABLE words (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      english TEXT NOT NULL,
      meaning TEXT,
      category TEXT NOT NULL,
      isWrong INTEGER NOT NULL DEFAULT 0
    )
  ''');
    await _insertInitialWords(db);
  }
  // 데이터 베이스가 생성 됨과 동시에 JSON파일에 있는 단어를 데이터 베이스에 넣는다
  Future _insertInitialWords(Database db) async {
    try {
      String data = await rootBundle.loadString('assets/data/words.json');
      List<dynamic> words = jsonDecode(data);
      for (var word in words) {
        await db.insert('words', word);
      }
    } catch (e) {
      log('데이터베이스 <- 단어 입력 오류 word : $e');
    }
  }
}