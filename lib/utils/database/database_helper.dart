import 'package:face_recognition/utils/database/scipts_database.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> initDatabase() async {
    if (_database != null) {
      return _database!;
    } else {
      return await openDatabase(
        'face_recognition.db',
        version: 1,
        onCreate: (db, version) async {
          await SciptsDatabase.createTableNotes(db);
          await SciptsDatabase.createTableUser(db);
        },
      );
    }
  }
}
