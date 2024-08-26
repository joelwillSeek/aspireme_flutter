import 'dart:convert';

import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:sqflite/sqflite.dart';

class Sqldatabase {
  static String databaseName = "AspireMe.db";
  static int version = 2;
  static String noteTableName = "Notes";
  static String folderTableName = "Folders";
  static String folderTableQuery =
      "create table $folderTableName (id integer primary key autoincrement,name text,subNotesId text,subFoldersId text,parentId integer null)";
  static String noteTableQuery =
      "create table $noteTableName (id integer primary key autoincrement,title text,description text,dateTime text,parentId integer)";

  static Future<Database> getDatabase() async {
    return openDatabase(join(await getDatabasesPath(), databaseName),
        version: version, onCreate: (innerDatabase, version) async {
      await innerDatabase.execute(folderTableQuery);
      await innerDatabase.execute(noteTableQuery);
    });
  }

  //Folder functionally
  static Future<Folder?> getRootFolder() async {
    try {
      Folder? rootFolder = await getFolder(1);

      if (rootFolder == null) {
        Folder innerRootFolder = Folder(name: "root", parentId: null);

        return await createAFolder(innerRootFolder);
      } else {
        return rootFolder;
      }
    } catch (e) {
      print("get root folder: $e");
    }

    return null;
  }

  static Future<Folder?> createAFolder(Folder folder) async {
    try {
      final database = await getDatabase();

      final folderCreated = await database.insert(
          folderTableName, folder.fromFolderToJson(),
          conflictAlgorithm: ConflictAlgorithm.fail);

      folder.id = folderCreated;

      Future<void> addToParent() async {
        Folder? parentFolder = await getFolder(folder.parentId!);

        if (parentFolder == null) {
          debugPrint("Error $parentFolder");
          return;
        }

        parentFolder.addSubFolder = folder;

        //update the parent folder
        await updateAFolder(parentFolder);
      }

      if (folder.parentId != null) {
        await addToParent();
      }

      return folder;
    } catch (e) {
      debugPrint("create A Folder Error: $e");
    }

    return null;
  }

  static Future<List<Folder?>> foldersIdJsonToList(List decodedIds) async {
    List<Folder?> tempFoldersHolder = [];
    for (var id in decodedIds) {
      final folderReceived = await Sqldatabase.getFolder(id);
      tempFoldersHolder.add(folderReceived);
    }
    return tempFoldersHolder;
  }

  static Future<List<Note?>> NotesIdJsonToList(List decodedIds) async {
    List<Note?> tempNotesHolder = [];
    for (var id in decodedIds) {
      final noteReceived = await Sqldatabase.getNote(id);
      tempNotesHolder.add(noteReceived);
    }
    return tempNotesHolder;
  }

  static Future<Folder?> getFolder(int id) async {
    final database = await getDatabase();

    final folderInJson =
        await database.query(folderTableName, where: "id = ?", whereArgs: [id]);

    if (folderInJson.isEmpty) return null;

    final jsonFolder = folderInJson.first;

    final subFolders = await foldersIdJsonToList(
        jsonDecode(jsonFolder["subFoldersId"] as String));

    final subNotes =
        await NotesIdJsonToList(jsonDecode(jsonFolder["subNotesId"] as String));

    final newJson = {
      "id": jsonFolder["id"],
      "name": jsonFolder["name"],
      "subNotesId": subNotes,
      "subFoldersId": subFolders,
      "parentId": jsonFolder["parentId"],
    };

    Folder folderForm = Folder.fromJsonToFolder(newJson);

    return folderForm;
  }

  static Future resetDatabase() async {
    final Database = await getDatabase();

    await Database.delete(folderTableName);
    await Database.delete(noteTableName);
  }

//this function is for debug only
  static Future<void> getFoldersWithCustomQuery() async {
    final db = await getDatabase();

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $folderTableName');

    print(result);
  }

  static Future<void> updateAFolder(Folder folder) async {
    try {
      final database = await getDatabase();

      if (folder.name == "root") {
        print("folder subfolder ${folder.getSubFolders}");
        final nu = await database.update(
            folderTableName, folder.fromFolderToJson(imARootFolder: true),
            where: "id = ?", whereArgs: [1]);

        print("me here bro $nu");
        return;
      }

      await database.update(
          folderTableName, folder.fromFolderToJson(assignId: false),
          where: "id = ?", whereArgs: [folder.id]);
    } catch (e) {
      print("update a folder $e");
    }
  }

//Note functionally

//this function is for debug only
  static Future<void> getNotesWithCustomQuery() async {
    final db = await getDatabase();

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $noteTableName');

    print(result);
  }

  static Future<Note?> createANote(Note note) async {
    try {
      final database = await getDatabase();

      print("noter ${note.FromNoteToJson()}");

      final noteCreatedId = await database.insert(
          noteTableName, note.FromNoteToJson(),
          conflictAlgorithm: ConflictAlgorithm.fail);

      note.id = noteCreatedId;

      Future<void> addToParent() async {
        Folder? parentFolder = await getFolder(note.parentId);

        if (parentFolder == null) {
          debugPrint("Error $parentFolder");
          return;
        }

        parentFolder.addSubNote = note;

        //update the parent folder
        await updateAFolder(parentFolder);
      }

      await addToParent();

      return note;
    } catch (e) {
      debugPrint("Create a note Error: $e");
    }
    return null;
  }

  static Future<Note?> getNote(int id) async {
    try {
      final database = await getDatabase();

      final noteInJson =
          await database.query(noteTableName, where: "id = ?", whereArgs: [id]);

      Note noteForm = Note.FromJsonToNote(noteInJson.first);

      return noteForm;
    } catch (e) {
      print("get note function: $e");
    }
    return null;
  }
}
