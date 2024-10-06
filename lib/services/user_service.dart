import 'dart:convert';

import 'package:face_recognition/utils/database/database_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sqflite/sqflite.dart';

class UserService {
  final DatabaseHelper _databaseHelper = Modular.get<DatabaseHelper>();

  Future<void> createUser(String name, List<dynamic> faceData) async {
    final Database database = await _databaseHelper.initDatabase();

    final String faceDataString = jsonEncode(faceData);

    await database.insert(
      'user',
      {
        'name': name,
        'face': faceDataString,
      },
    );
  }
}
