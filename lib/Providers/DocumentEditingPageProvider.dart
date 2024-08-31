import 'package:aspireme_flutter/BackEnd/Models/DocumentModel.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/SqlDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DocumentEditingPageProvider extends ChangeNotifier {
  List<Note?> _listOfNotes = [];

  late DocumentModel _beingViewed;

  final emptyNote = Note(
      title: "",
      description: "",
      dateTime: DateFormat("dd/mm/yy").format(DateTime.now()),
      parentId: 0);

  List<Note?> get getListOfNotes {
    print("list of note ${_listOfNotes.first}");
    return _listOfNotes;
  }

  set setBeingViewedDocument(DocumentModel document) {
    _beingViewed = document;
    setListOfNotes();
    notifyListeners();
  }

  get getBeingViewedDocument => _beingViewed;

  void setListOfNotes() {
    if (_listOfNotes.isNotEmpty) return;
    _listOfNotes = _beingViewed.getSubNotesId;

    _listOfNotes.add(emptyNote);
    notifyListeners();
    return;
  }

  int get getListLength {
    print("length ${_listOfNotes.length}");

    if (_listOfNotes.isEmpty) {
      _listOfNotes.add(emptyNote);
    }

    return _listOfNotes.length;
  }

  Future<void> addNote(
    String title,
    String description,
  ) async {
    _listOfNotes.removeLast();
    final addNoteWithOutId = Note(
        title: title,
        description: description,
        dateTime: DateFormat("dd/mm/yy").format(DateTime.now()),
        parentId: _beingViewed.getId);

    try {
      print("add note $title");
      final addNoteWIthId = await Sqldatabse.createANote(addNoteWithOutId);

      _listOfNotes.add(addNoteWIthId);
      _listOfNotes.add(emptyNote);
    } catch (e) {
      debugPrint("Add Note Document Editing : $e");
    }

    notifyListeners();
  }
}
