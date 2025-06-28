import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlHelper {
  Database? database;
  getDatabase() async {
    if (database == null) {
      database = await initDataBase();
      return database;
    } else {
      return database;
    }
  }

  initDataBase() async {
    String path = join(await getDatabasesPath(), 'Notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, index) async {
        db.batch().execute('''
          CREATE TABLE Notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT, 
          content TEXT
          )
        ''');
        db.batch().commit();
      },
    );
  }

  addNote(newNote) async {
    Database db = getDatabase();
    await db.insert(
      newNote,
      newNote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
