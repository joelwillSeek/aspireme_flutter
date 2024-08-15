import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/BackEnd/SqlDatabase.dart';
import 'package:flutter/material.dart';

class Folderprovider extends ChangeNotifier {
  late List<Folder> allFolders;

  Future<List<Folder>> get getAllFolders async {
    allFolders = await Sqldatabase.getAllFolders();
    return allFolders;
  }

  set setAllFolders(Folder folder) {
    Sqldatabase.createAFolder(folder);
    notifyListeners();
  }
}
