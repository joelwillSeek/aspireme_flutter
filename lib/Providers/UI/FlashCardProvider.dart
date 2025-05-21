import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/Database/sql_flash_card_function.dart';
import 'package:aspireme_flutter/BackEnd/Database/sql_note_functions.dart';
import 'package:flutter/material.dart';

class FlashCardProvider extends ChangeNotifier {
  List<Note?> _wrongNotes = [];
  final List<Note?> _seeinNotes = [];

  bool showDescription = false;

  set setShowDescription(bool value) {
    showDescription = value;
    notifyListeners();
  }

  get getShowDescription => showDescription;

  Future<void> getAllWrongNotes(BuildContext context) async {
    _wrongNotes.clear();

    final receivedWrongNotes = await Sqlflashcardfunction.getWrongCard();

    if (receivedWrongNotes != null) {
      _wrongNotes = receivedWrongNotes;

      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No notes found")));
    }
  }

  Note? getNoteToShow() {
    if (_wrongNotes.isEmpty) {
      return null;
    }

    //have a condition where after seeing all the wrong notes we can say either that it or see more other notes
    return _wrongNotes.last;
  }

  void setCorrectNote(Note note) async {
    note.isWrongAnswer = false;

    await Sqlnotefunctions.updateNote(note);

    final theLastOne = _wrongNotes.removeLast();

    if (_wrongNotes.isNotEmpty) {
      _seeinNotes.add(theLastOne);
    }

    showDescription = false;

    notifyListeners();
  }

  void addToWrong(Note wrongNote) async {
    wrongNote.isWrongAnswer = true;
    await Sqlnotefunctions.updateNote(wrongNote);

    final theLastOne = _wrongNotes.removeLast();

    if (_wrongNotes.isNotEmpty) {
      _seeinNotes.add(theLastOne);
    }

    showDescription = false;

    notifyListeners();
  }
}
