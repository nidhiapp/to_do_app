import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:to_do_application/model/add_note_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db = null;

  DatabaseHelper._instance();

  String noteTable = "note_Table";
  String colTitle = "title";
  String colId = "id";
  String colStatus = "status";
  String colPriority = "priority";
  String colDate = "date";

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "to_do_List.dB";
    final todoListDB =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDB;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,
    $colTitle TEXT, $colDate TEXT, $colPriority TEXT, $colStatus  INTEGER)''');
  }

  //interacting with the database now

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(noteTable);
    return result;
  }

  Future<List<AddNoteModel>> getNotesList() async {
    final List<Map<String, dynamic>> noteMapList = await getNoteMapList();

    List<AddNoteModel> noteList = [];
    noteMapList.forEach((noteMap) {
      noteList.add(AddNoteModel.fromMap(noteMap));
    });
    noteList.sort((noteA, noteB) => noteA.date!.compareTo(noteB.date!));
    return noteList;
  }

  Future<int> insertNote(AddNoteModel note) async {
    Database? db = await this.db;
    final int result = await db!.insert(noteTable, note.toMap(),
      );
    return result;
  }

  Future<int> updateNote(AddNoteModel note) async {
    Database? db = await this.db;
    final int result = await db!.update(noteTable, note.toMap(),
       where: '$colId = ?', whereArgs: [note.id]
);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database? db = await this.db;
    final int result =
        await db!.delete(noteTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }
}
