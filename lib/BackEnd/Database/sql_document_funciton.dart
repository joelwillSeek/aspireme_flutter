//Document Functionally

import 'dart:convert';

import 'package:aspireme_flutter/BackEnd/Models/document_model.dart';
import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/Database/sql_database.dart';
import 'package:aspireme_flutter/BackEnd/Database/sql_folder_function.dart';
import 'package:aspireme_flutter/BackEnd/Database/sql_note_functions.dart';
import 'package:flutter/material.dart';

class Sqldocumentfunciton {
  static Future<List> getRawDocumentModels() async {
    try {
      final database = await Sqldatabse.getDatabase();

      return await database.query(Sqldatabse.nameDocumentTable);
    } catch (e) {
      debugPrint("getRawDocumentModels : $e");
    }

    throw ("Not Supposed to throw null at end");
  }

  static Future<List<Note?>> NotesIdJsonToList(List decodedIds) async {
    List<Note?> tempNotesHolder = [];
    if (decodedIds.isEmpty) return tempNotesHolder;
    for (var id in decodedIds) {
      final noteReceived = await Sqlnotefunctions.getNote(id);
      tempNotesHolder.add(noteReceived);
    }
    return tempNotesHolder;
  }

  static Future<DocumentModel?> createDocument(DocumentModel document) async {
    Future<void> addToParent(DocumentModel childDocument) async {
      print("parent id ${childDocument.getParentId}");
      Folder? parentFolder =
          await Sqlfolderfunction.getFolder(childDocument.getParentId!);

      if (parentFolder == null) {
        throw Exception("Error $parentFolder");
      }

      parentFolder.addSubDocuments = childDocument;

      //update the parent folder
      await Sqlfolderfunction.updateAFolder(parentFolder);
    }

    try {
      final database = await Sqldatabse.getDatabase();

      final idOfDocument = await database.insert(
          Sqldatabse.nameDocumentTable, document.fromDocumentToJson());

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
        await Sqlnotefunctions.removeNote(subNote!);
      }
    }

    Future deleteReferenceInParent(DocumentModel deletableDocument) async {
      if (deletableDocument.getId == null ||
          deletableDocument.getParentId == null) {
        throw Exception(
            "Folder id or parent id null : ${deletableDocument.fromDocumentToJson()}");
      }

      final getParentFolder =
          await Sqlfolderfunction.getFolder(deletableDocument.getParentId!);

      if (getParentFolder == null) {
        throw Exception("Folder null : ${getParentFolder?.fromFolderToJson()}");
      }

      getParentFolder.removeASubDocument = deletableDocument;

      await Sqlfolderfunction.updateAFolder(getParentFolder);
    }

    try {
      final database = await Sqldatabse.getDatabase();

      await deleteSubNotes(document);
      await deleteReferenceInParent(document);

      if (document.getId == null) {
        throw Exception("Document id null ${document.fromDocumentToJson()}");
      }

      final deletedFolder = await database.delete(Sqldatabse.nameDocumentTable,
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
      final database = await Sqldatabse.getDatabase();

      final documentInJson = await database.query(Sqldatabse.nameDocumentTable,
          where: "id = ?", whereArgs: [documentId]);

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

  static Future<void> updateADocument(DocumentModel document) async {
    try {
      final database = await Sqldatabse.getDatabase();

      await database.update(
          Sqldatabse.nameDocumentTable, document.fromDocumentToJson(),
          where: "id = ?", whereArgs: [document.getId]);
    } catch (e) {
      debugPrint("update a document : $e");
    }
  }

  static Future<void> shiftDocumentFoldertoFolder(
      DocumentModel document, int newParentFolderId) async {
    try {
      await removeCurrentParentFolder(document);
      await addToNewParentFolder(newParentFolderId, document);
    } catch (e) {
      debugPrint("shift a document from folder to folder : $e");
    }
  }

  static Future<void> removeCurrentParentFolder(DocumentModel document) async {
    try {
      final getParentFolder =
          await Sqlfolderfunction.getFolder(document.getParentId);

      if (getParentFolder == null) {
        throw Exception("Parent Folder not found removeCurrentFolder");
      } else if (getParentFolder.getSubDocuments.isEmpty) {
        throw Exception(
            "child document doesnt exist of any kind removeCurrentFolder");
      }
      getParentFolder.getSubDocuments.removeWhere(
          (documentInner) => documentInner!.getId == document.getId);

      await Sqlfolderfunction.updateAFolder(getParentFolder);
    } catch (e) {
      debugPrint("SHift DoucmentFoldertoFodler : $e");
    }
  }

  static Future<void> addToNewParentFolder(
      int newParentFolderId, DocumentModel documentModel) async {
    try {
      final getParentFolder =
          await Sqlfolderfunction.getFolder(newParentFolderId);

      if (getParentFolder == null) {
        throw Exception("Parent Folder not found addToNewParentFolder");
      }

      documentModel.setParentId = newParentFolderId;

      getParentFolder.addSubDocuments = documentModel;

      await updateADocument(documentModel);

      await Sqlfolderfunction.updateAFolder(getParentFolder);
    } catch (e) {
      debugPrint("SHift DoucmentFoldertoFodler : $e");
    }
  }
}
