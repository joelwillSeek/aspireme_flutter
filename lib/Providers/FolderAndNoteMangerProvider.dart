import 'dart:ffi';

import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/SqlDatabase.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderAndNoteManagerProvider extends ChangeNotifier {
  final rootFolder = Folder(name: "root", id: null);

  List<Folder> stackOfOpenFolders = [];

  int amountOfNotes = 0;

  set addFolder(Folder newFolder) {
    makeSureRootFolderIsRoot();
    stackOfOpenFolders.last.addSubFolder = newFolder;

    notifyListeners();
  }

  set openFolder(Folder newFolder) {
    makeSureRootFolderIsRoot();
    stackOfOpenFolders.add(newFolder);

    notifyListeners();
  }

  bool closedFolder(BuildContext context) {
    if (stackOfOpenFolders.last.name == "root") {
      return false;
    }

    stackOfOpenFolders.removeAt(stackOfOpenFolders.length - 1);
    notifyListeners();
    return true;
  }

  List get getCurrentlyBeingViewedFolderContent {
    makeSureRootFolderIsRoot();
    final listOfNotes = stackOfOpenFolders.last.getSubNotes;

    final listOfSubFolders = stackOfOpenFolders.last.getSubFolders;

    return [...listOfSubFolders, ...listOfNotes];
  }

  void makeSureRootFolderIsRoot() {
    if (!stackOfOpenFolders.isEmpty) {
      if (stackOfOpenFolders.first == rootFolder) {
        return;
      }
    }

    stackOfOpenFolders.insert(0, rootFolder);
  }

  set addNotes(Note newNote) {
    makeSureRootFolderIsRoot();

    stackOfOpenFolders.last.addSubNote = newNote;
    amountOfNotes++;
    notifyListeners();
  }

  void deleteFolder(Folder deleteFolder) {
    makeSureRootFolderIsRoot();
    stackOfOpenFolders.last.getSubFolders.remove(deleteFolder);
    notifyListeners();
  }

  void deleteNote(Note deleteNote) {
    makeSureRootFolderIsRoot();
    stackOfOpenFolders.last.getSubNotes.remove(deleteNote);
    amountOfNotes++;
    notifyListeners();
  }
}
