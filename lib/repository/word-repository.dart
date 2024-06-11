import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../db/db.dart';
import '../model/category-word.model.dart';

class WordRepository {
  final DatabaseHelper _databaseHelper;

  WordRepository(this._databaseHelper);
  //하나의 카테고리 단어를 모두 불러오는 함수
  Future<List<Word>> getWordsByCategory(String? category) async {
    if (category == null) {
      log('category를 넣어주세요');
    }
    final db = await _databaseHelper.database;
    final result = await db.query('words', where: 'category = ?', whereArgs: [category]);
    List<Word> words = result.map((map) => Word.fromMap(map)).toList();
    return words;
  }
  // 모든 단어를 불러오는 함수
  Future<List<Map<String, dynamic>>> getAllWords() async {
    final db = await _databaseHelper.database;
    final result = await db.query('words');
    return result;
  }
  // 오답 처리를 해주는 함수
  Future<List<Word>> getWrongAnswer() async {
    final db = await _databaseHelper.database;
    final result = await db.query(
      'words',
      where: 'isWrong = ?',
      whereArgs: [1],
    );

    List<Word> words = result.map((map) => Word.fromMap(map)).toList();
    return words;
  }
  // 데이터베이스에 있는 데이터 전부 삭제
  Future<void> deleteDatabaseFile() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'words.db');
    await deleteDatabase(path);
  }
  // 오답 처리를 해주는 함수
  Future<void> updateWrongAnswer(String? correctWord) async {
    var db = await _databaseHelper.database;
    await db.update(
      'words',
      {'isWrong': 1},
      where: 'meaning = ?',
      whereArgs: [correctWord],
    );
  }
  // 정답 처리를 해주는 함수
  Future<void> updateCorrectAnswer(String correctWord) async {
    var db = await _databaseHelper.database;
    await db.update(
      'words',
      {'isWrong' : 0},
      where : 'meaning = ?',
      whereArgs: [correctWord],
    );
  }
}