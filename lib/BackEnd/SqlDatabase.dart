import 'dart:convert';

import 'package:aspireme_flutter/BackEnd/Models/DocumentModel.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
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
          nameFolderTable, folder.fromFolderToJson(),
          conflictAlgorithm: ConflictAlgorithm.fail);

      folder.id = folderCreated;

      Future<void> addToParent() async {
        Folder? parentFolder = await getFolder(folder.getParentId!);

        if (parentFolder == null) {
          debugPrint("Error $parentFolder");
          return;
        }

        parentFolder.addSubFolder = folder;

        //update the parent folder
        await updateAFolder(parentFolder);
      }

      if (folder.getParentId != null) {
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
      final folderReceived = await Sqldatabse.getFolder(id);
      tempFoldersHolder.add(folderReceived);
    }
    return tempFoldersHolder;
  }

  static Future<List<DocumentModel?>> documentIdJsonToList(
      List decodedIds) async {
    List<DocumentModel?> tempDocumentsHolder = [];
    for (var id in decodedIds) {
      final documentReceived = await Sqldatabse.getDocument(id);

      tempDocumentsHolder.add(documentReceived);
    }
    return tempDocumentsHolder;
  }

  static Future<Folder?> getFolder(int id) async {
    final database = await getDatabase();

    final folderInJson =
        await database.query(nameFolderTable, where: "id = ?", whereArgs: [id]);

    if (folderInJson.isEmpty) return null;

    final jsonFolder = folderInJson.first;

    final subFolders = await foldersIdJsonToList(
        jsonDecode(jsonFolder["subFoldersId"] as String));

    final subDocuments = await documentIdJsonToList(
        jsonDecode(jsonFolder["subDocumentId"] as String));

    final newJson = {
      "id": jsonFolder["id"],
      "name": jsonFolder["name"],
      "subDocumentId": subDocuments,
      "subFoldersId": subFolders,
      "parentId": jsonFolder["parentId"],
    };

    Folder folderForm = Folder.fromJsonToFolder(newJson);

    return folderForm;
  }

  static Future resetDatabase() async {
    final Database = await getDatabase();

    await Database.delete(nameFolderTable);
    await Database.delete(nameNoteTable);
  }

//this function is for debug only
  static Future<void> getFoldersWithCustomQuery() async {
    final db = await getDatabase();

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $nameFolderTable');

    print(result);
  }

  static Future<void> updateAFolder(Folder folder) async {
    try {
      final database = await getDatabase();

      if (folder.name == "root") {
        final nu = await database.update(
            nameFolderTable, folder.fromFolderToJson(imARootFolder: true),
            where: "id = ?", whereArgs: [1]);

        print("me here bro $nu");
        return;
      }

      await database.update(
          nameFolderTable, folder.fromFolderToJson(assignId: false),
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
        await db.rawQuery('SELECT * FROM $nameNoteTable');

    print(result);
  }

  static Future<Note?> createANote(Note note) async {
    try {
      final database = await getDatabase();

      print("noter ${note.FromNoteToJson()}");

      final noteCreatedId = await database.insert(
          nameNoteTable, note.FromNoteToJson(),
          conflictAlgorithm: ConflictAlgorithm.fail);

      note.id = noteCreatedId;

      Future<void> addToParent() async {
        DocumentModel? parentDocument = await getDocument(note.parentId);

        if (parentDocument == null) {
          throw Exception("Error $parentDocument");
        }

        parentDocument.addSubNote = note;

        //update the parent folder
        await updateADocument(parentDocument);
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
          await database.query(nameNoteTable, where: "id = ?", whereArgs: [id]);

      Note noteForm = Note.FromJsonToNote(noteInJson.first);

      return noteForm;
    } catch (e) {
      print("get note function: $e");
    }
    return null;
  }

  static Future<List<Note>?> getAllNotes() async {
    try {
      final database = await getDatabase();

      final allNote = await database.query(nameNoteTable);

      List<Note> listOfNotes = [];

      if (allNote.isNotEmpty) {
        listOfNotes =
            allNote.map((element) => Note.FromJsonToNote(element)).toList();
      }

      return listOfNotes;
    } catch (e) {
      print("Get all note sql ; $e");
    }
    return null;
  }

  static removeFolder(Folder folder) async {
    Future deleteSubFolders() async {
      if (folder.getSubFolders.isEmpty) return;

      for (var subFolder in folder.getSubFolders) {
        await removeFolder(subFolder!);
      }
    }

    Future deleteSubDocuments() async {
      if (folder.getSubDocuments.isEmpty) return;

      for (var subDocument in folder.getSubDocuments) {
        await removeDocument(subDocument!);
      }
    }

    Future deleteReferenceInParent() async {
      if (folder.id == null || folder.getParentId == null) {
        throw Exception(
            "Folder id or parent id null : ${folder.fromFolderToJson()}");
      }

      final getParentFolder = await getFolder(folder.getParentId!);

      if (getParentFolder == null) {
        throw Exception("Folder null : ${folder.fromFolderToJson()}");
      }

      getParentFolder.removeASubFolder = folder;

      await updateAFolder(getParentFolder);
    }

    try {
      final database = await getDatabase();

      await deleteSubFolders();
      await deleteSubDocuments();
      await deleteReferenceInParent();

      //notify parent too
      if (folder.id == null) {
        throw Exception("Folder id null ${folder.fromFolderToJson()}");
      }

      final deletedFolder = await database
          .delete(nameFolderTable, where: "id = ?", whereArgs: [folder.id]);

      if (deletedFolder <= 0) {
        throw Exception("Row not deleted ${folder.fromFolderToJson()}");
      }
    } catch (e) {
      print("Remove Folder Sql Error: $e");
    }
  }

  static removeNote(Note note) async {
    Future deleteReferenceInParent(Note noteDeleteParent) async {
      if (noteDeleteParent.id == null) {
        throw Exception("Note id null : ${note.FromNoteToJson()}");
      }

      final getParentDocument = await getDocument(noteDeleteParent.parentId);

      if (getParentDocument == null) {
        throw Exception("Document null : ${note.FromNoteToJson()}");
      }

      getParentDocument.removeSubNote = note;

      await updateADocument(getParentDocument);
    }

    try {
      final database = await getDatabase();

      if (note.id == null) {
        throw Exception("Note Id Null ${note.FromNoteToJson()}");
      }

      await deleteReferenceInParent(note);

      final deletedNote = await database
          .delete(nameNoteTable, where: "id = ?", whereArgs: [note.id]);

      if (deletedNote <= 0) {
        throw Exception("Row not deleted ${note.FromNoteToJson()}");
      }
    } catch (e) {
      print("Remove Note : $e");
    }
  }

  static void updateNote(Note note) async {
    try {
      final database = await getDatabase();

      await database.update(nameNoteTable, note.FromNoteToJson(withId: false),
          where: "id = ?", whereArgs: [note.id]);
    } catch (e) {
      print("Set correct note : $e");
    }
  }

  //Document Functionally

  static Future<List<Note?>> NotesIdJsonToList(List decodedIds) async {
    List<Note?> tempNotesHolder = [];
    if (decodedIds.isEmpty) return tempNotesHolder;
    for (var id in decodedIds) {
      final noteReceived = await Sqldatabse.getNote(id);
      tempNotesHolder.add(noteReceived);
    }
    return tempNotesHolder;
  }

  static Future<void> getDocumentsWithCustomQuery() async {
    final db = await getDatabase();

    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $nameDocumentTable');

    print("Document Table: $result");
  }

  static Future<DocumentModel?> createDocument(DocumentModel document) async {
    Future<void> addToParent(DocumentModel childDocument) async {
      Folder? parentFolder = await getFolder(childDocument.getParentId!);

      if (parentFolder == null) {
        throw Exception("Error $parentFolder");
      }

      parentFolder.addSubDocuments = childDocument;

      //update the parent folder
      await updateAFolder(parentFolder);
    }

    try {
      final database = await getDatabase();

      final idOfDocument = await database.insert(
          nameDocumentTable, document.fromDocumentToJson());

      document.setId = idOfDocument;

      await addToParent(document);

      return document;
    } catch (e) {
      print("create document sql : $e");
    }

    return null;
  }

  static removeDocument(DocumentModel document) async {
    Future deleteSubNotes(DocumentModel deletableDocument) async {
      if (deletableDocument.getSubNotesId.isEmpty) return;

      for (var subNote in deletableDocument.getSubNotesId) {
        await removeNote(subNote!);
      }
    }

    Future deleteReferenceInParent(DocumentModel deletableDocument) async {
      if (deletableDocument.getId == null ||
          deletableDocument.getParentId == null) {
        throw Exception(
            "Folder id or parent id null : ${deletableDocument.fromDocumentToJson()}");
      }

      final getParentFolder = await getFolder(deletableDocument.getParentId!);

      if (getParentFolder == null) {
        throw Exception("Folder null : ${getParentFolder?.fromFolderToJson()}");
      }

      getParentFolder.removeASubDocument = deletableDocument;

      await updateAFolder(getParentFolder);
    }

    try {
      final database = await getDatabase();

      await deleteSubNotes(document);
      await deleteReferenceInParent(document);

      if (document.getId == null) {
        throw Exception("Document id null ${document.fromDocumentToJson()}");
      }

      final deletedFolder = await database.delete(nameDocumentTable,
          where: "id = ?", whereArgs: [document.getId]);

      if (deletedFolder <= 0) {
        throw Exception("Row not deleted ${document.fromDocumentToJson()}");
      }
    } catch (e) {
      print("delete Document function sql: $e");
    }
  }

  static Future<DocumentModel?> getDocument(int documentId) async {
    try {
      final database = await getDatabase();

      final documentInJson = await database
          .query(nameDocumentTable, where: "id = ?", whereArgs: [documentId]);

      if (documentInJson.isEmpty) return null;

      final jsonDocument = documentInJson.first;

      final subNotes = await NotesIdJsonToList(
          jsonDecode(jsonDocument["subNotesId"] as String));

      final newJson = {
        "id": jsonDocument["id"],
        "name": jsonDocument["name"],
        "subNotesId": subNotes,
        "parentId": jsonDocument["parentId"],
      };

      DocumentModel documentForm = DocumentModel.fromJsonToFolder(newJson);

      return documentForm;
    } catch (e) {
      debugPrint("get document sql: $e");
    }
    return null;
  }

  static updateADocument(DocumentModel document) async {
    try {
      final database = await getDatabase();

      await database.update(nameDocumentTable, document.fromDocumentToJson(),
          where: "id = ?", whereArgs: [document.getId]);
    } catch (e) {
      debugPrint("update a document : $e");
    }
  }

// Flashcard Functionally
  static Future<List<Note>?> getWrongCard() async {
    try {
      final database = await getDatabase();
      //wrongAnswer 1 means true and 0 means false
      final allWrongNotes = await getAllNotes();

      print("all note $allWrongNotes");

      if (allWrongNotes == null) return null;

      if (allWrongNotes.isEmpty) {
        return allWrongNotes;
      }

      return allWrongNotes.where((note) => note.isWrongAnswer == true).toList();
    } catch (e) {
      print("Wrong Card sql: $e");
    }
    return null;
  }
}
