import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/Database/SqlNoteFunctions.dart';

class Sqlflashcardfunction {
// Flashcard Functionally
  static Future<List<Note>?> getWrongCard() async {
    try {
      // final database = await getDatabase();
      //wrongAnswer 1 means true and 0 means false
      final allWrongNotes = await Sqlnotefunctions.getAllNotes();

      if (allWrongNotes == null) return null;

      if (allWrongNotes.isEmpty) {
        return allWrongNotes;
      }

      final verifiedWorngNote =
          allWrongNotes.where((note) => note.isWrongAnswer == true).toList();

      if (verifiedWorngNote.isEmpty) {
        return allWrongNotes;
      }

      return verifiedWorngNote;
    } catch (e) {
      print("Wrong Card sql: $e");
    }
    return null;
  }
}
