
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Sqldatabse {
  static String databaseName = "AspireMe.db";
  static int version = 2;

  //table names
  static String nameNoteTable = "Notes";
  static String nameFolderTable = "Folders";
  static String nameDocumentTable = "Documents";
  static String nameFlashCardTable = "FlashCards";

  //query
  static String queryDocumentTable =
      "create table $nameDocumentTable (id integer primary key autoincrement,subNotesId text,parentId integer,name text)";
  static String queryFolderTable =
      "create table $nameFolderTable (id integer primary key autoincrement,name text,subDocumentId text,subFoldersId text,parentId integer null)";
  static String queryNoteTable =
      "create table $nameNoteTable (id integer primary key autoincrement,title text,description text,dateTime text,parentId integer,wrongAnswer integer)";

  static Future<Database> getDatabase() async {
    return openDatabase(join(await getDatabasesPath(), databaseName),
        version: version, onCreate: (innerDatabase, version) async {
      await innerDatabase.execute(queryFolderTable);
      await innerDatabase.execute(queryNoteTable);
      await innerDatabase.execute(queryDocumentTable);
    });
  }

  static Future resetDatabase() async {
    final Database = await getDatabase();

    await Database.delete(nameFolderTable);
    await Database.delete(nameNoteTable);
  }

  static Future<void> getFoldersWithCustomQuery() async {
    final db = await getDatabase();

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $nameFolderTable');

    print(result);
  }

  static Future<void> getDocumentsWithCustomQuery() async {
    final db = await Sqldatabse.getDatabase();

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM ${Sqldatabse.nameDocumentTable}');

    print("document $result");
  }

  static Future<void> getNotesWithCustomQuery() async {
    final db = await Sqldatabse.getDatabase();

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM ${Sqldatabse.nameNoteTable}');

    print(result);
  }
}
