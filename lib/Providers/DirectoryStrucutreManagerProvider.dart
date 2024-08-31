import 'package:aspireme_flutter/BackEnd/Models/DocumentModel.dart';
import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/SqlDatabase.dart';
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
  void addFolder(
    String name,
  ) async {
    await makeSureRootFolderIsRoot();

    final newFolderNoId =
        Folder(name: name, parentId: getCurrentlyBeingViewedFolder.id);

    final newFolderWithID = await Sqldatabse.createAFolder(
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

  Future<List> get getCurrentlySelectedSubDocuments async {
    await makeSureRootFolderIsRoot();

    final listOfSubDocuments = _stackOfOpenFolders.last.getSubDocuments;

    print("gay $listOfSubDocuments");

    return listOfSubDocuments;
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
      final rootFolder = await Sqldatabse.getRootFolder();

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
      await Sqldatabse.removeFolder(deleteFolder);

      _stackOfOpenFolders.last.getSubFolders.remove(deleteFolder);
    } catch (e) {
      print("Delete Folder Error: $e");
    }

    notifyListeners();
  }

//document functions

  Future<void> addDocument(
    String name,
  ) async {
    try {
      await makeSureRootFolderIsRoot();

      final newFolderNoId = DocumentModel(
          name: name, parentId: getCurrentlyBeingViewedFolder.id!);

      final newDocumentWithID = await Sqldatabse.createDocument(
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
      await Sqldatabse.removeDocument(deleteDocument);

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
      await Sqldatabse.removeNote(deleteNote);
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

      final newNoteWithId = await Sqldatabse.createANote(newNoteNoId);

      documentBeingBViewed.addSubNote = newNoteWithId;
    } catch (e) {
      debugPrint("Add Note Function Error : $e");
    }
  }

  //   notifyListeners();
  // }

  // List<Note?>? get getCurrentlyBeingViewSubNotes =>
  //     _stackOfOpenFolders.last.getSubNotes;

// Future<List> get getCurrentlySelectedSubNotes async {
//     await makeSureRootFolderIsRoot();

//     final listOfSubNotes = _stackOfOpenFolders.last.getSubNotes;

//     print("list note $listOfSubNotes");

//     return listOfSubNotes ?? [];
//   }
}
