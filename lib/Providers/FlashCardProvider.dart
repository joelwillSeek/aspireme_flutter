import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/SqlDatabase.dart';
import 'package:flutter/material.dart';

class FlashCardProvider extends ChangeNotifier {
  List<Note?> _wrongNotes = [];

  Future<void> getAllWrongNotes() async {
    _wrongNotes.clear();
    final receivedWrongNotes = await Sqldatabse.getWrongCard();

    print("called");

    if (receivedWrongNotes != null) _wrongNotes = receivedWrongNotes;
  }

  Note? getNoteToShow() {
    if (_wrongNotes.isEmpty) {
      return null;
    }
    //have a condition where after seeing all the wrong notes we can say either that it or see more other notes
    return _wrongNotes.removeLast();
  }

  set setCorrectNote(Note note) {
    note.isWrongAnswer = false;

    Sqldatabse.updateNote(note);
    notifyListeners();
  }

  set addToWrong(Note wrongNote) {
    wrongNote.isWrongAnswer = true;
    Sqldatabse.updateNote(wrongNote);

    notifyListeners();
  }
}
