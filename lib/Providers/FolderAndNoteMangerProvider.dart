import 'dart:convert';

import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/SqlDatabase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FolderAndNoteManagerProvider extends ChangeNotifier {
  //root node id is always 1
  List<Folder> _stackOfOpenFolders = [];

  Folder get getCurrentlyBeingViewedFolder => _stackOfOpenFolders.last;

  bool concurrentInsertionOfRootLock = false;

  Future<void> resetStructure() async {
    _stackOfOpenFolders.clear();

    await makeSureRootFolderIsRoot();

    notifyListeners();
  }

  void addFolder(
    String name,
  ) async {
    await makeSureRootFolderIsRoot();

    final newFolderNoId =
        Folder(name: name, parentId: getCurrentlyBeingViewedFolder.id);

    final newFolderWithID = await Sqldatabase.createAFolder(
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
      await _stackOfOpenFolders.removeLast();
    } else {
      print("The stack is already empty.");
    }

    notifyListeners();
    return true;
  }

  Future<List> get getCurrentlySelectedSubFolders async {
    await makeSureRootFolderIsRoot();

    final listOfSubFolders = _stackOfOpenFolders.last.getSubFolders;

    return listOfSubFolders ?? [];
  }

  Future<List> get getCurrentlySelectedSubNotes async {
    await makeSureRootFolderIsRoot();

    final listOfSubNotes = _stackOfOpenFolders.last.getSubNotes;

    print("list note $listOfSubNotes");

    return listOfSubNotes ?? [];
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
      final rootFolder = await Sqldatabase.getRootFolder();

      if (rootFolder != null) {
        _stackOfOpenFolders.insert(0, rootFolder);
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

  void addNotes(String title, String description) async {
    await makeSureRootFolderIsRoot();

    try {
      final newNoteNoId = Note(
          title: title,
          description: description,
          dateTime: DateFormat("dd/mm/yy").format(DateTime.now()),
          parentId: getCurrentlyBeingViewedFolder.id!);

      final newNoteWithId = await Sqldatabase.createANote(newNoteNoId);

      print("notes $newNoteWithId");

      _stackOfOpenFolders.last.addSubNote = newNoteWithId;
    } catch (e) {
      print("Add Note Function Error : $e");
    }

    notifyListeners();
  }

  void deleteFolder(Folder deleteFolder) {
    makeSureRootFolderIsRoot();

    _stackOfOpenFolders.last.getSubFolders?.remove(deleteFolder);
    notifyListeners();
  }

  void deleteNote(Note deleteNote) {
    makeSureRootFolderIsRoot();
    _stackOfOpenFolders.last.getSubNotes?.remove(deleteNote);
    notifyListeners();
  }

  List<Note?>? get getCurrentlyBeingViewSubNotes =>
      _stackOfOpenFolders.last.getSubNotes;

  List get getTheStack => _stackOfOpenFolders;
}
