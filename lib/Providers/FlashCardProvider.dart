import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/Providers/FolderAndNoteMangerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashCardProvider extends ChangeNotifier {
  final List<Note?> _wrongNotes = [];

  Note? getNoteToShow(BuildContext context) {
    final managerRef = context.read<FolderAndNoteManagerProvider>();

    // final rand = Random();

    if (_wrongNotes.isEmpty &&
        managerRef.getCurrentlyBeingViewSubNotes!.isNotEmpty) {
      // final noteID = rand.nextInt(managerRef.amountOfNotes);
      // get randomly but for now just get the notes in root

      _wrongNotes.add(managerRef.getCurrentlyBeingViewSubNotes!.last);

      return _wrongNotes.removeAt(0);
    }

    if (_wrongNotes.isEmpty &&
        managerRef.getCurrentlyBeingViewSubNotes!.isEmpty) {
      return null;
    }

    final removedNote = _wrongNotes.removeAt(0);

    return removedNote;
  }

  set addToWrong(Note wrongNote) {
    _wrongNotes.add(wrongNote);

    notifyListeners();
  }
}
