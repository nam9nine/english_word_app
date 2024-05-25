
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
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        english TEXT,
        meaning TEXT
      )
    ''');
    await _insertInitialWords(db);
  }

  Future _insertInitialWords(Database db) async {
    const initialWords = [
      {'english': 'apple', 'meaning': 'A fruit', 'category' : 'Travel'},
      {'english': 'book', 'meaning': 'A set of written pages','category' : 'Travel'},
      {'english': 'cat', 'meaning': 'A small domestic animal'}
    ];
    for (var word in initialWords) {
      await db.insert('words', word);
    }
  }
}