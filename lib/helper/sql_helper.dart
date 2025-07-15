import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/note_model.dart';


class SqlHelper {
  static Database? database;

  static getDatabase() async {
    if (database != null) {
      return database;
    } else {
      database = await initDataBase();
      return database;
    }
  }

  static initDataBase() async {
    String path = join(await getDatabasesPath(), 'engRehamNotesApp.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, index) {
        Batch batch = db.batch();
        batch.execute('''
          CREATE TABLE Notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT, 
          content TEXT
          )
        ''');
        batch.commit();
      },
    );
  }

  static Future addNote(Note newNote) async {
    Database db = await getDatabase();
    await db.insert(
      'Notes',
      newNote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map>> loadDate()async{
    Database db = await getDatabase();
    return await db.query('Notes');
  }

  static Future updatenote(Note newnote)async{
    Database db = await getDatabase();
    await db.update('Notes',
    newnote.toMap(),
        where: 'id=?',
        whereArgs: [newnote.id]
    );
  }

  static Future deletenote(int id) async{
    Database db = getDatabase();
    await db.delete(
        'Notes',
      where: 'id=?',
      whereArgs: [id]
    );
  }

  static Future deleteallnote() async{
    Database db = getDatabase();
    await db.delete('Notes');
  }
}
