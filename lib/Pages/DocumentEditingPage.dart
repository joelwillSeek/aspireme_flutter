import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/Pages/Components/CustomTopAppBar.dart';
import 'package:aspireme_flutter/Providers/DocumentEditingPageProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DocumentEditingPage extends StatelessWidget {
  DocumentEditingPage({super.key});

  final FocusNode focusNode = FocusNode();

  Widget noteCardWidget(
      Note? note,
      BuildContext context,
      TextEditingController questionEditingController,
      TextEditingController answerEditingController) {
    return Card(
      shadowColor: Colors.transparent,
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Question",
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ),
          TextField(
            style: const TextStyle(backgroundColor: Colors.transparent),
            keyboardType: TextInputType.text,
            controller: questionEditingController,
            decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                labelStyle: const TextStyle(color: Colors.black),
                fillColor: Colors.transparent,
                hintText: "How to ....",
                label: Text(note?.title ?? "")),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Answer",
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ),
          TextField(
            controller: answerEditingController,
            style: const TextStyle(backgroundColor: Colors.transparent),
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.transparent,
                hintText: "Step 1) ....",
                label: Text(note?.description ?? '')),
            // onSubmitted: (content) {
            //   print("entered");
            //   makeNewNote();
            // },
          ),
        ],
      ),
    );
  }

  Widget NoteWidget(
      Note? note, int index, int listLength, BuildContext context) {
    TextEditingController questionEditingController = TextEditingController();
    TextEditingController answerEditingController = TextEditingController();
    void makeNewNote() {
      print("enter pressed");
      Provider.of<DocumentEditingPageProvider>(context, listen: false).addNote(
          questionEditingController.text, answerEditingController.text);

      FocusScope.of(context).requestFocus(focusNode);
    }

    return index >= listLength - 1 || note == null
        ? KeyboardListener(
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                makeNewNote();
              }
            },
            focusNode: focusNode,
            child: noteCardWidget(note, context, questionEditingController,
                answerEditingController))
        : noteCardWidget(
            note, context, questionEditingController, answerEditingController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Customtopappbar(),
        ),
        body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            margin: const EdgeInsets.all(0),
            child: ListView.builder(
                itemCount: Provider.of<DocumentEditingPageProvider>(context)
                    .getListLength,
                itemBuilder: (context, index) => NoteWidget(
                    Provider.of<DocumentEditingPageProvider>(context)
                        .getListOfNotes[index]!,
                    index,
                    Provider.of<DocumentEditingPageProvider>(context)
                        .getListLength,
                    context))));
  }
}
