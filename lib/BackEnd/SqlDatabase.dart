import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqldatabase {
  static String databaseName = "AspireMe.db";
  static int version = 1;
  static String noteTableName = "Notes";
  static String folderTableName = "folders";

  static Future<Database> getDatabase() async {
    return openDatabase(join(await getDatabasesPath(), databaseName),
        version: version, onCreate: (innerDatabase, version) {
      innerDatabase.execute(
          "create table $folderTableName(id integer primary key autoincrement,name text)");
      innerDatabase.execute(
          "create table $noteTableName(id integer primary key autoincrement,title text,description text,dateTime text,folderId integer)");
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

    final list_Of_Folders_In_Map_Format =
        await database.rawQuery("select * from $folderTableName");

    return List.generate(
        list_Of_Folders_In_Map_Format.length,
        (index) =>
            Folder.FromJsonToFolder(list_Of_Folders_In_Map_Format[index]));
  }

  // Future<int> insertAQuestionWithNotes(Note question) async {
  //   final database = await getDatabase();

  //   return await database.insert(
  //       questionWithNotesTableName, question.FromQuestionWithNotesToJson(),
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  // Future<int> updateAQuestionWithNotes(Note question) async {
  //   final database = await getDatabase();

  //   return await database.update(
  //       questionWithNotesTableName, question.FromQuestionWithNotesToJson(),
  //       where: "id = ?",
  //       whereArgs: [question.id],
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  // Future<int> deleteAQuestionWithNotes(Note question) async {
  //   final database = await getDatabase();

  //   return await database.delete(questionWithNotesTableName,
  //       where: "id = ?", whereArgs: [question.id]);
  // }

  // Future<List<Note>?> getAllQuestionWithNotes() async {
  //   final database = await getDatabase();

  //   final allQuestionWithNotesInMapForm =
  //       await database.query(questionWithNotesTableName);

  //   if (allQuestionWithNotesInMapForm.isEmpty) return null;

  //   return List.generate(
  //       allQuestionWithNotesInMapForm.length,
  //       (index) => Note.fromJsonToQuestionsWithNotes(
  //           allQuestionWithNotesInMapForm[index]));
  // }
}
