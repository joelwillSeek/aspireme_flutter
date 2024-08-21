import 'dart:math';

import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/Providers/FolderAndNoteMangerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashCardAlgorithm {
  static List<Note> _wrongNotes = [];
  //make a method to get all the notes from sql

  static Note getOneNote(BuildContext context) {
    final rand = Random();
    if (_wrongNotes.isEmpty) {
      final noteID = rand
          .nextInt(context.read<FolderAndNoteManagerProvider>().amountOfNotes);
      //get randomly but for now just get the notes in root
      return context
          .read<FolderAndNoteManagerProvider>()
          .stackOfOpenFolders
          .last
          .getSubNotes[0];
    }

    return _wrongNotes.first;
  }
}
