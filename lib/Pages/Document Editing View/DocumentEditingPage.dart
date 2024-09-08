import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/CustomTopAppBar.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
import 'package:aspireme_flutter/Providers/DirectoryStrucutreManagerProvider.dart';
import 'package:aspireme_flutter/Providers/DocumentEditingPageProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DocumentEditingPage extends StatelessWidget {
  DocumentEditingPage({super.key});

  final FocusNode focusNode = FocusNode();

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
                itemBuilder: (context, index) => NoteWidgetView(
                    focusNode: focusNode,
                    note: Provider.of<DocumentEditingPageProvider>(context)
                        .getListOfNotes[index]!,
                    index: index,
                    listLength:
                        Provider.of<DocumentEditingPageProvider>(context)
                            .getListLength))));
  }
}

class NoteWidgetView extends StatefulWidget {
  final Note? note;
  final int index;
  final int listLength;
  final FocusNode focusNode;

  NoteWidgetView(
      {required this.focusNode,
      required this.index,
      required this.note,
      required this.listLength,
      super.key});

  @override
  State<NoteWidgetView> createState() => _NoteWidgetViewState();
}

class _NoteWidgetViewState extends State<NoteWidgetView> {
  TextEditingController questionEditingController = TextEditingController();

  TextEditingController answerEditingController = TextEditingController();
  bool hasEnteredInput = false;

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
          ),
        ],
      ),
    );
  }

  Future<void> makeNewNote(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const LoadingWidget());
    await Provider.of<DocumentEditingPageProvider>(context, listen: false)
        .addNote(questionEditingController.text, answerEditingController.text);

    if (context.mounted) {
      Navigator.pop(context);
      FocusScope.of(context).requestFocus(widget.focusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.focusNode.addListener(() async {
      if (widget.focusNode.hasFocus) {
        hasEnteredInput = true;
        print("foucss");
      }

      if (!hasEnteredInput) {
        await context.read<DirectoryStructureManagerProvider>().updateNote(
            questionEditingController.text,
            answerEditingController.text,
            widget.note!.parentId);
        hasEnteredInput = false;
      }
    });
    return widget.index >= widget.listLength - 1 || widget.note == null
        ? KeyboardListener(
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                makeNewNote(context);
              }
            },
            focusNode: widget.focusNode,
            child: noteCardWidget(widget.note, context,
                questionEditingController, answerEditingController))
        : noteCardWidget(widget.note, context, questionEditingController,
            answerEditingController);
  }
}
