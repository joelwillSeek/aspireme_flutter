//Folder functionally

import 'dart:convert';

import 'package:aspireme_flutter/BackEnd/Models/DocumentModel.dart';
import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/BackEnd/Database/SqlDatabase.dart';
import 'package:aspireme_flutter/BackEnd/Database/SqlDocumentFunciton.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Sqlfolderfunction {
  static Future<Folder?> getRootFolder() async {
    try {
      Folder? rootFolder = await getFolder(1);

      if (rootFolder == null) {
        final database = await Sqldatabse.getDatabase();

        final doesRootExist = await database.query(Sqldatabse.nameFolderTable,
            where: "name = ?", whereArgs: ["root"]);

        print("passed");

        if (doesRootExist.isNotEmpty) {
          throw Exception(
              "root exists but cant get the folder ${rootFolder?.fromFolderToJson()}, the data fetched ${doesRootExist.first}");
        }

        Folder innerRootFolder = Folder(name: "root", parentId: null);

        return await createAFolder(innerRootFolder);
      } else {
        return rootFolder;
      }
    } catch (e) {
      debugPrint("get root folder: $e");
    }

    return null;
  }

  static Future<Folder?> createAFolder(Folder folder) async {
    try {
      final database = await Sqldatabse.getDatabase();

      final folderCreated = await database.insert(
          Sqldatabse.nameFolderTable, folder.fromFolderToJson(),
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
      final folderReceived = await Sqlfolderfunction.getFolder(id);
      tempFoldersHolder.add(folderReceived);
    }
    return tempFoldersHolder;
  }

  static Future<List<DocumentModel?>> documentIdJsonToList(
      List decodedIds) async {
    List<DocumentModel?> tempDocumentsHolder = [];
    for (var id in decodedIds) {
      final documentReceived = await Sqldocumentfunciton.getDocument(id);

      tempDocumentsHolder.add(documentReceived);
    }
    return tempDocumentsHolder;
  }

  static Future<Folder?> getFolder(int id) async {
    final database = await Sqldatabse.getDatabase();

    final folderInJson = await database
        .query(Sqldatabse.nameFolderTable, where: "id = ?", whereArgs: [id]);

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

  static Future<void> updateAFolder(Folder folder) async {
    try {
      final database = await Sqldatabse.getDatabase();

      if (folder.name == "root") {
        await database.update(Sqldatabse.nameFolderTable,
            folder.fromFolderToJson(imARootFolder: true),
            where: "id = ?", whereArgs: [1]);

        return;
      }

      await database.update(
          Sqldatabse.nameFolderTable, folder.fromFolderToJson(assignId: false),
          where: "id = ?", whereArgs: [folder.id]);
    } catch (e) {
      print("update a folder $e");
    }
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
        await Sqldocumentfunciton.removeDocument(subDocument!);
      }
    }

    Future deleteReferenceInParent() async {
      if (folder.id == null || folder.getParentId == null) {
        throw Exception(
            "Folder id or parent id null : ${folder.fromFolderToJson()}");
      }

      final getParentFolder =
          await Sqlfolderfunction.getFolder(folder.getParentId!);

      if (getParentFolder == null) {
        throw Exception("Folder null : ${folder.fromFolderToJson()}");
      }

      getParentFolder.removeASubFolder = folder;

      await Sqlfolderfunction.updateAFolder(getParentFolder);
    }

    try {
      final database = await Sqldatabse.getDatabase();

      await deleteSubFolders();
      await deleteSubDocuments();
      await deleteReferenceInParent();

      //notify parent too
      if (folder.id == null) {
        throw Exception("Folder id null ${folder.fromFolderToJson()}");
      }

      final deletedFolder = await database.delete(Sqldatabse.nameFolderTable,
          where: "id = ?", whereArgs: [folder.id]);

      if (deletedFolder <= 0) {
        throw Exception("Row not deleted ${folder.fromFolderToJson()}");
      }
    } catch (e) {
      print("Remove Folder Sql Error: $e");
    }
  }

  static Future<void> shiftFolderFromFolderToNewFolder(
      Folder folder, int newParentFolderId) async {
    try {
      if (folder.id == null) {
        throw Exception("folder.id");
      }
      await removeCurrentParentFolder(folder);
      await addToNewParentFolder(newParentFolderId, folder);
    } catch (e) {
      debugPrint("shift a folder from folder to folder : $e");
    }
  }

  static Future<void> removeCurrentParentFolder(Folder folder) async {
    try {
      if (folder.getParentId == null) {
        throw Exception("Folder  paretn id is null");
      }
      final getParentFolder =
          await Sqlfolderfunction.getFolder(folder.getParentId!);

      if (getParentFolder == null) {
        throw Exception("Parent Folder not found removeCurrentFolder");
      } else if (getParentFolder.getSubFolders.isEmpty) {
        throw Exception(
            "child Folder doesnt exist of any kind removeCurrentFolder");
      }
      getParentFolder.getSubFolders
          .removeWhere((innerFolder) => innerFolder!.id == folder.id);

      await updateAFolder(getParentFolder);
    } catch (e) {
      debugPrint("SHift FolderFromFoldertoFodler : $e");
    }
  }

  static Future<void> addToNewParentFolder(
      int newParentFolderId, Folder folder) async {
    try {
      final getParentFolder =
          await Sqlfolderfunction.getFolder(newParentFolderId);

      if (getParentFolder == null) {
        throw Exception("Parent Folder not found addToNewParentFolder");
      }

      folder.setParentId = newParentFolderId;

      getParentFolder.addSubFolder = folder;

      await updateAFolder(folder);

      await updateAFolder(getParentFolder);
    } catch (e) {
      debugPrint("SHift DoucmentFoldertoFodler : $e");
    }
  }
}
