import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/Pages/NotesEditingPage.dart';
import 'package:aspireme_flutter/Providers/FolderAndNoteMangerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesWidget extends StatelessWidget {
  final Note note;
  const NotesWidget({required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    void longPressClicked() {
      final RenderBox widgetBox = context.findRenderObject() as RenderBox;
      final Offset widgetPosition = widgetBox.localToGlobal(Offset.zero);
      final Size widgetSize = widgetBox.size;

      final RenderBox overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;

      showMenu(
          color: Theme.of(context).colorScheme.secondary,
          context: context,
          position: RelativeRect.fromLTRB(
            widgetPosition.dx +
                widgetSize.width, // Slightly to the right of the widget
            widgetPosition.dy, // Align vertically with the widget
            overlay.size.width -
                widgetPosition.dx -
                widgetSize.width, // Remaining space on the right
            overlay.size.height -
                widgetPosition.dy, // Remaining space at the bottom
          ),
          items: [
            PopupMenuItem(
              onTap: () {
                context.read<FolderAndNoteManagerProvider>().deleteNote(note);
              },
              value: 'Option 1',
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ]);
    }

    return GestureDetector(
      onLongPress: longPressClicked,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Noteseditingpage(
                  title: note.title,
                  discription: note.description,
                )));
      },
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            titleAndDate(context),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                height: 3.0,
                margin: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            discriptionComponent(context),
          ],
        ),
      ),
    );
  }

  Widget discriptionComponent(BuildContext context) {
    String toViewDiscribtion = note.description;
    if (toViewDiscribtion.length > 50) {
      int howMuchLetterToView = (toViewDiscribtion.length * 0.20).round();
      toViewDiscribtion = toViewDiscribtion.substring(0, howMuchLetterToView);
      toViewDiscribtion += "...";
    }

    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Text(
        textAlign: TextAlign.left,
        toViewDiscribtion,
        style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      ),
    );
  }

  Widget titleAndDate(BuildContext context) {
    String dateTimeString = note.dateTime;
    return Container(
        margin: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              note.title,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ),
            Text(
              dateTimeString,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            )
          ],
        ));
  }
}
