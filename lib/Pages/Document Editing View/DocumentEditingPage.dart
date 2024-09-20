import 'dart:async';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/CustomTopAppBar.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
import 'package:aspireme_flutter/Providers/DocumentEditingPageProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DocumentEditingPage extends StatelessWidget {
  const DocumentEditingPage({super.key});

  Widget listBuilder(BuildContext context) {
    List<Note?> listOfNotes =
        Provider.of<DocumentEditingPageProvider>(context).getListOfNotes;

    return ListView.builder(
        itemCount: listOfNotes.length,
        itemBuilder: (context, index) =>
            NoteWidgetView(note: listOfNotes[index], index: index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            margin: const EdgeInsets.all(0),
            child: listBuilder(context)));
  }
}

class NoteWidgetView extends StatefulWidget {
  final Note? note;
  final int index;

  const NoteWidgetView({required this.index, required this.note, super.key});

  @override
  State<NoteWidgetView> createState() => _NoteWidgetViewState();
}

class _NoteWidgetViewState extends State<NoteWidgetView> {
  TextEditingController questionEditingController = TextEditingController();

  TextEditingController answerEditingController = TextEditingController();

  FocusNode toAnswerFocuse = FocusNode();
  bool saved = true;

  Timer? enterKeyTimer;
  bool waitingForSecondPress = false;
  final int doubleTapThreshold = 300;

  @override
  void dispose() {
    enterKeyTimer?.cancel();
    questionEditingController.dispose();
    answerEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //parent id 0 means its an empty note

    return Card(
      shadowColor: Colors.transparent,
      color: Colors.transparent,
      child: Column(
        children: [
          Row(
            children: [
              labelForEditText("Question"),
              Text(
                saved ? "Saved" : "Not Saved",
                style: TextStyle(color: saved ? Colors.green : Colors.red),
              )
            ],
          ),
          editableTextWidget(widget.note!.title, "How to ...."),
          labelForEditText("Answer"),
          editableTextWidget(widget.note!.description, "Step 1) ....",
              answer: true),
        ],
      ),
    );
  }

  Widget labelForEditText(String value) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        value,
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.left,
      ),
    );
  }

  Future<void> updateTheNote(int? noteId, {bool isQuestion = false}) async {
    if (widget.note?.parentId == 0) {
      await Provider.of<DocumentEditingPageProvider>(context, listen: false)
          .addNote(questionEditingController.text, answerEditingController.text,
              isQuestion);
    } else {
      await context.read<DocumentEditingPageProvider>().updateNote(
          noteId,
          questionEditingController.text,
          answerEditingController.text,
          widget.note?.parentId);

      print("updateder pls");
    }

    setState(() {
      saved = true;
    });
  }

  Future<void> onAnswerSubmit(KeyEvent? event) async {
    if (event == null) return;
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.enter) {
      return;
    }

    if (waitingForSecondPress) {
      waitingForSecondPress = false;

      enterKeyTimer?.cancel();

      answerEditingController.text = answerEditingController.text.trim();

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const LoadingWidget());
      await updateTheNote(widget.note?.id);

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } else {
      waitingForSecondPress = true;
      enterKeyTimer = Timer(Duration(milliseconds: doubleTapThreshold), () {
        waitingForSecondPress = false;
        enterKeyTimer?.cancel();
      });
    }
  }

  void onQuestionSubmit(value) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const LoadingWidget());

    await updateTheNote(widget.note?.id);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
    FocusScope.of(context).requestFocus(toAnswerFocuse);
  }

  Widget editableTextWidget(String value, String hint, {bool answer = false}) {
    if (answer && answerEditingController.text.trim().isEmpty) {
      answerEditingController.text = value;
    } else if (!answer && questionEditingController.text.trim().isEmpty) {
      questionEditingController.text = value;
    }

    ///for some resone the questtion text editer wont listen to enter
    ///so i changed it to onsubmit
    return KeyboardListener(
        onKeyEvent: onAnswerSubmit,
        focusNode: FocusNode(),
        child: TextField(
          onSubmitted: answer ? null : onQuestionSubmit,
          maxLength: null,
          maxLines: answer ? null : 1,
          onChanged: (value) {
            setState(() {
              saved = false;
            });
          },
          style:
              const TextStyle(backgroundColor: Color.fromARGB(0, 41, 37, 37)),
          controller:
              answer ? answerEditingController : questionEditingController,
          focusNode: answer ? toAnswerFocuse : null,
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            labelStyle: const TextStyle(color: Colors.black),
            fillColor: Colors.transparent,
            hintText: hint,
          ),
        ));
  }
}
