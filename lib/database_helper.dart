import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FlashcardDatabaseHelper {
  static const _databaseName = "flashcard_database.db";
  static const _databaseVersion = 1;

  static const table = 'flashcards';

  static const columnId = '_id';
  static const columnQuestion = 'question';
  static const columnOptions = 'options';
  static const columnCorrectOption = 'correctOption';

  FlashcardDatabaseHelper._privateConstructor();
  static final FlashcardDatabaseHelper instance =
      FlashcardDatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnQuestion TEXT NOT NULL,
            $columnOptions TEXT NOT NULL,
            $columnCorrectOption TEXT NOT NULL
          )
          ''');
  }

  Future<void> insertFlashcard(Map<String, dynamic> row) async {
    Database db = await instance.database;
    await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> getAllFlashcards() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(table);
    return result;
  }

  Future<int> deleteFlashcard(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
