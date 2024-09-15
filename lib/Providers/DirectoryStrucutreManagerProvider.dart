import 'package:aspireme_flutter/BackEnd/Models/DocumentModel.dart';
import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/Database/SqlDocumentFunciton.dart';
import 'package:aspireme_flutter/BackEnd/Database/SqlFolderFunction.dart';
import 'package:aspireme_flutter/BackEnd/Database/SqlNoteFunctions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DirectoryStructureManagerProvider extends ChangeNotifier {
  //root node id is always 1
  final List<Folder> _stackOfOpenFolders = [];

  Folder get getCurrentlyBeingViewedFolder => _stackOfOpenFolders.last;

  bool concurrentInsertionOfRootLock = false;

  //stack functions
  List get getTheStack => _stackOfOpenFolders;

  Future<void> resetStructure() async {
    _stackOfOpenFolders.clear();

    await makeSureRootFolderIsRoot();

    notifyListeners();
  }

//Folder functions
  Future addFolder(
    String name,
  ) async {
    await makeSureRootFolderIsRoot();

    final newFolderNoId =
        Folder(name: name, parentId: getCurrentlyBeingViewedFolder.id);

    final newFolderWithID = await Sqlfolderfunction.createAFolder(
      newFolderNoId,
    );

    _stackOfOpenFolders.last.addSubFolder = newFolderWithID;

    notifyListeners();
  }

  set openFolder(Folder clickedFolder) {
    makeSureRootFolderIsRoot();
    _stackOfOpenFolders.add(clickedFolder);

    notifyListeners();
  }

  Future<bool> closedFolder(BuildContext context) async {
    if (_stackOfOpenFolders.last.name == "root") {
      return false;
    }

    if (_stackOfOpenFolders.isNotEmpty) {
      _stackOfOpenFolders.removeLast();
    } else {
      print("The stack is already empty.");
    }

    notifyListeners();
    return true;
  }

  Future<List> get getCurrentlySelectedSubFolders async {
    await makeSureRootFolderIsRoot();

    final listOfSubFolders = _stackOfOpenFolders.last.getSubFolders;

    return listOfSubFolders;
  }

  Future<List<dynamic>?> get getBothFoldersAndDocumentsByAlphabetial async {
    try {
      final folders = await getCurrentlySelectedSubFolders;
      final documents = await getCurrentlySelectedSubDocuments;

      final both = [...folders, ...documents];

      both.sort((a, b) {
        String stringA = "";
        String stringB = "";
        if (a is Folder) {
          stringA = a.name ?? "";
        } else if (a is DocumentModel) {
          stringA = a.getName ?? "";
        }

        if (b is Folder) {
          stringB = b.name ?? "";
        } else if (b is DocumentModel) {
          stringB = b.getName ?? "";
        }

        return stringA.compareTo(stringB);
      });

      return both;
    } catch (e) {
      debugPrint("Director ystructure Manager Provider get both foldres : $e");
    }
    return null;
  }

  Future<List<dynamic>> get getBothFoldersAndDocumentsByType async {
    final folders = await getCurrentlySelectedSubFolders;
    final documents = await getCurrentlySelectedSubDocuments;

    final both = [...folders, ...documents];

    return both;
  }

  Future<List> get getCurrentlySelectedSubDocuments async {
    await makeSureRootFolderIsRoot();

    final listOfSubDocuments = _stackOfOpenFolders.last.getSubDocuments;

    return listOfSubDocuments;
  }

  void clearListFolderOpen() async {
    _stackOfOpenFolders.clear();

    await makeSureRootFolderIsRoot();
    notifyListeners();
  }

  Future<void> makeSureRootFolderIsRoot() async {
    if (_stackOfOpenFolders.isNotEmpty) {
      if (_stackOfOpenFolders.first.id == 1) {
        return;
      }
    }

    if (concurrentInsertionOfRootLock) {
      // If another part of the code is already inserting the root folder, wait until it's done
      while (concurrentInsertionOfRootLock) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return; // After waiting, no need to insert again
    }

    concurrentInsertionOfRootLock = true;
    try {
      final rootFolder = await Sqlfolderfunction.getRootFolder();

      if (rootFolder != null) {
        _stackOfOpenFolders.insert(0, rootFolder);

        print("doucments presnet ${_stackOfOpenFolders.last.getSubDocuments}");
      } else {
        print("Error: Root folder could not be retrieved.");
      }
    } catch (e) {
      print("Error during database read: $e");
      // Consider adding retry logic or a fallback here
    } finally {
      concurrentInsertionOfRootLock = false;
    }
  }

  Future<void> deleteFolder(Folder deleteFolder) async {
    try {
      await makeSureRootFolderIsRoot();
      await Sqlfolderfunction.removeFolder(deleteFolder);

      _stackOfOpenFolders.last.getSubFolders.remove(deleteFolder);
    } catch (e) {
      print("Delete Folder Error: $e");
    }

    notifyListeners();
  }

//document functions

  Future<void> ShiftDocumentFolderToFolder(
      DocumentModel documentModel, int newParentId) async {
    try {
      await makeSureRootFolderIsRoot();

      await Sqldocumentfunciton.shiftDocumentFoldertoFolder(
          documentModel, newParentId);

      clearListFolderOpen();
    } catch (e) {
      print("ShiftDocumentFoldertoFolder Document : $e");
    }

    notifyListeners();
  }

  Future<void> shiftFolderFromFolderToNewFolder(
      Folder folder, int newParentFolderId) async {
    try {
      await makeSureRootFolderIsRoot();

      await Sqlfolderfunction.shiftFolderFromFolderToNewFolder(
          folder, newParentFolderId);

      clearListFolderOpen();
    } catch (e) {
      print("shiftFolderFromFolderToNewFolder Folder : $e");
    }

    notifyListeners();
  }

  Future<void> addDocument(
    String name,
  ) async {
    try {
      await makeSureRootFolderIsRoot();

      final newFolderNoId = DocumentModel(
          name: name, parentId: getCurrentlyBeingViewedFolder.id!);

      final newDocumentWithID = await Sqldocumentfunciton.createDocument(
        newFolderNoId,
      );

      _stackOfOpenFolders.last.addSubDocuments = newDocumentWithID;
    } catch (e) {
      print("Add Document : $e");
    }

    notifyListeners();
  }

  Future<void> deleteDocument(DocumentModel deleteDocument) async {
    try {
      await makeSureRootFolderIsRoot();
      await Sqldocumentfunciton.removeDocument(deleteDocument);

      _stackOfOpenFolders.last.getSubDocuments.remove(deleteDocument);
    } catch (e) {
      print("Delete Folder Error: $e");
    }

    notifyListeners();
  }

//notes functions
  Future<void> deleteNote(
      Note deleteNote, DocumentModel documentBeingSeeing) async {
    try {
      await makeSureRootFolderIsRoot();
      await Sqlnotefunctions.removeNote(deleteNote);
      documentBeingSeeing.getSubNotesId.remove(deleteNote);
    } catch (e) {
      print("Delete Note Error: $e");
    }

    notifyListeners();
  }

  void addNotes(String title, String description,
      DocumentModel documentBeingBViewed) async {
    try {
      await makeSureRootFolderIsRoot();
      final newNoteNoId = Note(
          title: title,
          description: description,
          dateTime: DateFormat("dd/mm/yy").format(DateTime.now()),
          parentId: getCurrentlyBeingViewedFolder.id!);

      final newNoteWithId = await Sqlnotefunctions.createANote(newNoteNoId);

      documentBeingBViewed.addSubNote = newNoteWithId;
    } catch (e) {
      debugPrint("Add Note Function Error : $e");
    }
  }

  Future updateNote(String question, String answer, int parentId) async {
    try {
      await makeSureRootFolderIsRoot();

      final updatedNote = Note(
          title: question,
          description: answer,
          dateTime: DateFormat("dd/mm/yy").format(DateTime.now()),
          parentId: parentId);
      await Sqlnotefunctions.updateNote(updatedNote);
    } catch (e) {
      debugPrint("Update Note Function Error : $e");
    }
  }
}
