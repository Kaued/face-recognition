import 'package:sqflite/sqflite.dart';

class SciptsDatabase {
  static Future<void> createTableUser(Database database) async {
    await database.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        face TEXT
      )
    ''');
  }

  static Future<void> createTableNotes(Database database) async {
    await database.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE
      )
    ''');
  }
}
