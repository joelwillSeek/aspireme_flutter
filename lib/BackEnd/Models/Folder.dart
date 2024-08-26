import 'dart:convert';

import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/SqlDatabase.dart';

class Folder {
  int? id;
  String? name;
  //parentID null means root folder
  int? parentId;

  List<Folder?> subFolders = [];
  set addSubFolder(Folder? value) => subFolders.add(value);
  List<Folder?> get getSubFolders => subFolders;

  List<Note?> subNotes = [];
  List<Note?> get getSubNotes => subNotes;
  set addSubNote(Note? newNote) => subNotes.add(newNote);

  Folder({
    required this.name,
    this.id,
    required this.parentId,
    List<Folder?>? subFoldersValue,
    List<Note?>? subNotesValue,
  })  : subFolders = subFoldersValue ?? [],
        subNotes = subNotesValue ?? [];

  factory Folder.fromJsonToFolder(Map<String, dynamic> json) {
    final newFolder = Folder(
        name: json["name"],
        id: json["id"],
        parentId: json["parentId"],
        subFoldersValue: json["subFoldersId"],
        subNotesValue: json["subNotesId"]);

    return newFolder;
  }

  Map<String, dynamic> fromFolderToJson(
      {bool assignId = true, bool imARootFolder = false}) {
    final foldersIdsInString = _folderOrNoteIdToJson(subFolders);
    final notesIdsInString = _folderOrNoteIdToJson(subNotes);

    if (imARootFolder) {
      print("go home $foldersIdsInString");
      return {
        "name": "root",
        "parentId": null,
        "subFoldersId": foldersIdsInString,
        "subNotesId": notesIdsInString,
      };
    }

    if (assignId) {
      return {
        "id": id,
        "name": name,
        "subFoldersId": foldersIdsInString,
        "subNotesId": notesIdsInString,
        "parentId": parentId
      };
    }

    return {
      "name": name,
      "subFoldersId": foldersIdsInString,
      "subNotesId": notesIdsInString,
      "parentId": parentId
    };
  }

  String _folderOrNoteIdToJson(List wantToBeConverted) {
    final ids = [];

    for (var item in wantToBeConverted) {
      ids.add(item?.id);
    }

    print("aleast one $ids");

    return jsonEncode(ids);
  }
}
