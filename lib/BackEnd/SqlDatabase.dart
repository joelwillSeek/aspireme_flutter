import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqldatabase {
  static String databaseName = "AspireMe.db";
  static int version = 1;
  static String noteTableName = "Notes";
  static String folderTableName = "folders";
  static String folderTableQuery =
      "create table $folderTableName(id integer primary key autoincrement,name text)";
  static String noteTableQuery =
      "create table $noteTableName(id integer primary key autoincrement,title text,description text,dateTime text,folderId integer)";

  static Future<Database> getDatabase() async {
    return openDatabase(join(await getDatabasesPath(), databaseName),
        version: version, onCreate: (innerDatabase, version) {
      innerDatabase.execute(folderTableName);
      innerDatabase.execute(noteTableName);
    });
  }

  static Future<int> createAFolder(Folder folder) async {
    final database = await getDatabase();

    final folderCreated =
        await database.insert(folderTableName, folder.FromFolderToJson());

    return folderCreated;
  }

  static Future<List<Folder>> getAllFolders() async {
    final database = await getDatabase();

    final listOfFoldersInMapFormat =
        await database.rawQuery("select * from $folderTableName");

    final listOfFoldersInListFormat = List.generate(
        listOfFoldersInMapFormat.length,
        (index) => Folder.FromJsonToFolder(listOfFoldersInMapFormat[index]));

    for (var list in listOfFoldersInListFormat) {
      print(list.FromFolderToJson());
    }

    return listOfFoldersInListFormat;
  }

  static Future<List<Note>> getNotesForAFolder(int IdOfFolder) async {
    final database = await getDatabase();

    final listOfNotesInMapsFormat = await database
        .rawQuery("select * from $noteTableName where folderId = $IdOfFolder");

    final listOfNotesInNoteFormat = List.generate(
        listOfNotesInMapsFormat.length,
        (index) => Note.FromJsonToNote(listOfNotesInMapsFormat[index]));

    return listOfNotesInNoteFormat;
  }

  static Future<int> addNoteToFolder(Note newNote) async {
    final database = await getDatabase();

    print("created Note");

    return await database.insert(noteTableName, newNote.FromNoteToJson());
  }

  static Future resetDatabase() async {
    final Database = await getDatabase();

    await Database.delete(folderTableName);
    await Database.delete(noteTableName);

    await Database.execute(noteTableQuery);
    await Database.execute(folderTableQuery);
  }
}
