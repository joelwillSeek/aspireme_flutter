import 'dart:convert';

import 'package:aspireme_flutter/BackEnd/Models/document_model.dart';

class Folder {
  int? id;
  String? name;
  //parentID null means root folder
  int? _parentId;

  List<Folder?> _subFolders = [];

  List<DocumentModel?> _subDocuments = [];

  Folder({
    required this.name,
    this.id,
    required int? parentId,
    List<Folder?>? subFoldersValue,
    List<DocumentModel?>? subDocumentModel,
  })  : _parentId = parentId,
        _subFolders = subFoldersValue ?? [],
        _subDocuments = subDocumentModel ?? [];

  //getters
  List<Folder?> get getSubFolders => _subFolders;
  List<DocumentModel?> get getSubDocuments => _subDocuments;
  int? get getParentId => _parentId;

  //setter

  set setParentId(int? value) => _parentId = value;

  set addSubDocuments(DocumentModel? newDocument) =>
      _subDocuments.add(newDocument);

  set removeASubDocument(DocumentModel value) => _subDocuments.isEmpty
      ? null
      : _subDocuments.removeWhere((element) => element!.getId == value.getId);

  set addSubFolder(Folder? value) => _subFolders.add(value);

  set removeASubFolder(Folder value) => _subFolders.isEmpty
      ? null
      : _subFolders.removeWhere((element) => element!.id == value.id);

  factory Folder.fromJsonToFolder(Map<String, dynamic> json) {
    final newFolder = Folder(
        name: json["name"],
        id: json["id"],
        parentId: json["parentId"],
        subFoldersValue: json["subFoldersId"],
        subDocumentModel: json["subDocumentId"]);

    return newFolder;
  }

  Map<String, dynamic> fromFolderToJson(
      {bool assignId = true, bool imARootFolder = false}) {
    final foldersIdsInString = _folderOrDocumentIdToJson(_subFolders);
    final documentsIdsInString = _folderOrDocumentIdToJson(_subDocuments);

    if (imARootFolder) {
      return {
        "name": "root",
        "parentId": null,
        "subFoldersId": foldersIdsInString,
        "subDocumentId": documentsIdsInString,
      };
    }

    if (assignId) {
      return {
        "id": id,
        "name": name,
        "subFoldersId": foldersIdsInString,
        "subDocumentId": documentsIdsInString,
        "parentId": _parentId
      };
    }

    return {
      "name": name,
      "subFoldersId": foldersIdsInString,
      "subDocumentId": documentsIdsInString,
      "parentId": _parentId
    };
  }

  String _folderOrDocumentIdToJson(List wantToBeConverted) {
    final ids = [];

    for (var item in wantToBeConverted) {
      if (item is DocumentModel) {
        ids.add(item.getId);
      } else if (item is Folder) {
        ids.add(item.id);
      } else {
        throw Exception("$item is other data type in folderToJson convertion");
      }
    }

    return jsonEncode(ids);
  }
}
