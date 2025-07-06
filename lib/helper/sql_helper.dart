import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/note_model.dart';


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

  Future addNote(newNote) async {
    Database db = getDatabase();
    await db.insert(
      'Notes',
      newNote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map>> loadDate()async{
    Database db = getDatabase();
    return await db.query('Notes');
  }

  Future updatenote(Note newnote)async{
    Database db = await getDatabase();
    await db.update('Notes',
    newnote.toMap(),where: 'id=?',whereArgs: [newnote.id]
    );
  }

  Future deletenote(int id) async{
    Database db = getDatabase();
    await db.delete(
        'Notes',
      where: 'id=?',
      whereArgs: [id]
    );
  }

  Future deleteallnote() async{
    Database db = getDatabase();
    await db.delete('Notes');
  }
}
