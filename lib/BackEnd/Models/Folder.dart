import 'dart:collection';
import 'dart:convert';

import 'package:aspireme_flutter/BackEnd/Models/Note.dart';

class Folder {
  int? id;
  String? name;
  //0 means it has no parent folder

  List<Folder> _subFolders = [];
  set addSubFolder(Folder value) => _subFolders.add(value);
  List<Folder> get getSubFolders => _subFolders;

  List<Note> _subNotes = [];
  List<Note> get getSubNotes => _subNotes;
  set addSubNote(Note newNote) => _subNotes.add(newNote);

  Folder({required this.name, this.id});

  // factory Folder.FromJsonToFolder(Map<String, dynamic> json) {
  //   final allSubFolderIDs=List.generate();

  //   return Folder(
  //     name: json["name"],
  //     id: json["id"],
  //     parentFolderID: json["parentFolderID"],
  //     subFoldersId: jsonDecode(json["subFolders"]))
  // }
  // Map<String, dynamic> FromFolderToJson() => {
  //       'id': this.id,
  //       "name": this.name,
  //       "parentFolderID": this.parentFolderID,
  //       "subFolders": jsonEncode(this.subFoldersId)
  //     };
}
