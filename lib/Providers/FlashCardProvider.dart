import 'package:aspireme_flutter/BackEnd/FlashCardAlgorithm.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:flutter/material.dart';

class FlashCardProvider extends ChangeNotifier {
  Note getNoteToShow(BuildContext context) =>
      FlashCardAlgorithm.getOneNote(context);
}
