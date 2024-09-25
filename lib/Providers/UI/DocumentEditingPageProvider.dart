import 'package:aspireme_flutter/BackEnd/Database/SqlDocumentFunciton.dart';
import 'package:aspireme_flutter/BackEnd/Models/DocumentModel.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/Database/SqlNoteFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// there is always an empty note at the end of the list

class DocumentEditingPageProvider extends ChangeNotifier {
  List<Note?> _listOfNotes = [];

  late DocumentModel _beingViewed;

  final emptyNote = Note(
      title: "",
      description: "",
      dateTime: DateFormat("dd/mm/yy").format(DateTime.now()),
      parentId: 0);

  List<Note?> get getListOfNotes {
    return _listOfNotes;
  }

  set setBeingViewedDocument(DocumentModel document) {
    _listOfNotes.clear();

    _beingViewed = document;

    setListOfNotes();
  }

  get getBeingViewedDocument => _beingViewed;

  void setListOfNotes({bool dontAddEmpty = false}) {
    //if (_listOfNotes.first?.parentId != 0) return;

    _listOfNotes = _beingViewed.getSubNotesId;
    if (!dontAddEmpty) {
      _listOfNotes.add(emptyNote);
    }

    notifyListeners();
    return;
  }

  int get getListLength {
    if (_listOfNotes.isEmpty) {
      _listOfNotes.add(emptyNote);
    }

    return _listOfNotes.length;
  }

  Future<void> addNote(
      String title, String description, bool isQuestion) async {
    try {
      _listOfNotes.removeLast();
      final addNoteWithOutId = Note(
          title: title,
          description: description,
          dateTime: DateFormat("dd/mm/yy").format(DateTime.now()),
          parentId: _beingViewed.getId);

      final addNoteWIthId =
          await Sqlnotefunctions.createANote(addNoteWithOutId);

      _listOfNotes.add(addNoteWIthId);
      _listOfNotes.add(emptyNote);
    } catch (e) {
      debugPrint("Add Note Document Editing : $e");
    }

    notifyListeners();
  }

  Future<void> updateNote(
      int? noteId, String title, String desciption, int? parentId) async {
    try {
      final noteWithoutId = Note(
          id: noteId,
          title: title,
          description: desciption,
          dateTime: DateFormat("dd/mm/yy").format(DateTime.now()),
          parentId: parentId!);

      await Sqlnotefunctions.updateNote(noteWithoutId);

      setListWithUpdatedNotes();
    } catch (e) {
      debugPrint("update note doucment editing : $e");
    }

    notifyListeners();
  }

  Future<void> setListWithUpdatedNotes() async {
    try {
      setBeingViewedDocument =
          (await Sqldocumentfunciton.getDocument(_beingViewed.getId))!;

      setListOfNotes(dontAddEmpty: true);
    } catch (e) {
      debugPrint("Document Editing Page Provider set updated notes: $e");
    }

    notifyListeners();
    return;
  }

  Future<void> deleteNote(Note? note) async {
    try {
      await Sqlnotefunctions.removeNote(note!);
      _listOfNotes.removeWhere((value) => value?.id == note.id);
    } catch (e) {
      debugPrint("Docuemtn editing delete note : $e");
    }

    notifyListeners();
  }
}
