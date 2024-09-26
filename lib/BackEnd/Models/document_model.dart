import 'dart:convert';

import 'package:aspireme_flutter/BackEnd/Models/Note.dart';

class DocumentModel {
  int? _id;
  // ignore: prefer_final_fields
  List<Note?> _notes = [];
  String _name;
  int _parentId;

  DocumentModel(
      {int? id,
      List<Note?>? setNoteId,
      required String name,
      required int parentId})
      : _notes = setNoteId ?? [],
        _name = name,
        _id = id,
        _parentId = parentId;

  factory DocumentModel.fromJsonToFolder(Map<String, dynamic> json) =>
      DocumentModel(
          name: json["name"],
          parentId: json["parentId"],
          id: json["id"],
          setNoteId: json["subNotesId"]);

  get getId => _id;
  List<Note?> get getSubNotesId => _notes;
  get getName => _name;
  get getParentId => _parentId;

  set setId(int? id) => _id = id;
  set setParentId(int value) => _parentId = value;
  set addSubNote(Note? note) => _notes.add(note);
  set setName(String name) => _name = name;
  set removeSubNote(Note note) => getSubNotesId.isEmpty
      ? null
      : getSubNotesId.removeWhere((element) => element!.id == note.id);

  Map<String, dynamic> fromDocumentToJson() {
    final noteIdsInString = _noteIdToJson(getSubNotesId);

    return {
      "id": getId,
      "name": getName,
      "parentId": getParentId,
      "subNotesId": noteIdsInString,
    };
  }

  String _noteIdToJson(List wantToBeConverted) {
    final ids = [];

    for (var item in wantToBeConverted) {
      ids.add(item?.id);
    }

    return jsonEncode(ids);
  }
}
