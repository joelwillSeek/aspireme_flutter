import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/Pages/NotesEditingPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotesWidget extends StatelessWidget {
  final Note note;
  const NotesWidget({required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => Noteseditingpage(
        //           title: note.title,
        //           discription: note.description,
        //         ))

        //         );
      },
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        margin: EdgeInsets.all(20),
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
                margin: EdgeInsets.symmetric(vertical: 10),
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
      margin: EdgeInsets.all(20.0),
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
        margin: EdgeInsets.all(20.0),
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
