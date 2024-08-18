import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/SqlDatabase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderAndNoteProvider extends ChangeNotifier {
  late List<Note> _getAllNotesOfFolder = [];

  late List<Folder> _allFolders;
  int _currentlySelectedFolderID = 1;

  int get getCurrentlySelectedFolder => _currentlySelectedFolderID;

  set addNoteToFolder(Note newNote) {
    Sqldatabase.addNoteToFolder(newNote);
    notifyListeners();
  }

  Future<List<Note>> getNotesOfFolder(BuildContext context) async {
    _getAllNotesOfFolder =
        await Sqldatabase.getNotesForAFolder(getCurrentlySelectedFolder);

    return _getAllNotesOfFolder;
  }

  set setCurrentlySelectedFolder(int? value) {
    //maybe add and error if its null coz it should not
    //but for now its just sets 1 if there is no folder id
    _currentlySelectedFolderID = value ?? 1;
    notifyListeners();
  }

  Future<List<Folder>> get getAllFolders async {
    _allFolders = await Sqldatabase.getAllFolders();
    return _allFolders;
  }

  set setAllFolders(Folder folder) {
    Sqldatabase.createAFolder(folder);
    notifyListeners();
  }
}
