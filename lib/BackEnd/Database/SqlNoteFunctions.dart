import 'package:aspireme_flutter/BackEnd/Models/DocumentModel.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/Database/SqlDatabase.dart';
import 'package:aspireme_flutter/BackEnd/Database/SqlDocumentFunciton.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Sqlnotefunctions {
  static Future<List> getAllRawNotes() async {
    try {
      final database = await Sqldatabse.getDatabase();

      return await database.query(Sqldatabse.nameNoteTable);
    } catch (e) {
      debugPrint("getAllRawNotes : $e");
    }

    throw ("Not Supposed to throw null at end");
  }

  static Future<Note?> createANote(Note note) async {
    try {
      final database = await Sqldatabse.getDatabase();

      print("noter ${note.FromNoteToJson()}");

      final noteCreatedId = await database.insert(
          Sqldatabse.nameNoteTable, note.FromNoteToJson(),
          conflictAlgorithm: ConflictAlgorithm.fail);

      note.id = noteCreatedId;

      Future<void> addToParent() async {
        DocumentModel? parentDocument =
            await Sqldocumentfunciton.getDocument(note.parentId);

        if (parentDocument == null) {
          throw Exception("Error $parentDocument");
        }

        parentDocument.addSubNote = note;

        //update the parent folder
        await Sqldocumentfunciton.updateADocument(parentDocument);
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
      final database = await Sqldatabse.getDatabase();

      final noteInJson = await database
          .query(Sqldatabse.nameNoteTable, where: "id = ?", whereArgs: [id]);

      Note noteForm = Note.FromJsonToNote(noteInJson.first);

      return noteForm;
    } catch (e) {
      print("get note function: $e");
    }
    return null;
  }

  static Future<List<Note>?> getAllNotes() async {
    try {
      final database = await Sqldatabse.getDatabase();

      final allNote = await database.query(Sqldatabse.nameNoteTable);

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

  static removeNote(Note note) async {
    Future deleteReferenceInParent(Note noteDeleteParent) async {
      if (noteDeleteParent.id == null) {
        throw Exception("Note id null : ${note.FromNoteToJson()}");
      }

      final getParentDocument =
          await Sqldocumentfunciton.getDocument(noteDeleteParent.parentId);

      if (getParentDocument == null) {
        throw Exception("Document null : ${note.FromNoteToJson()}");
      }

      getParentDocument.removeSubNote = note;

      await Sqldocumentfunciton.updateADocument(getParentDocument);
    }

    try {
      final database = await Sqldatabse.getDatabase();

      if (note.id == null) {
        throw Exception("Note Id Null ${note.FromNoteToJson()}");
      }

      await deleteReferenceInParent(note);

      final deletedNote = await database.delete(Sqldatabse.nameNoteTable,
          where: "id = ?", whereArgs: [note.id]);

      if (deletedNote <= 0) {
        throw Exception("Row not deleted ${note.FromNoteToJson()}");
      }
    } catch (e) {
      print("Remove Note : $e");
    }
  }

  static Future<void> updateNote(Note note) async {
    try {
      final database = await Sqldatabse.getDatabase();

      await database.update(
          Sqldatabse.nameNoteTable, note.FromNoteToJson(withId: false),
          where: "id = ?", whereArgs: [note.id]);
    } catch (e) {
      print("Set correct note : $e");
    }
  }
}
