import 'package:aspireme_flutter/Pages/NotesEditingPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notes extends StatelessWidget {
  final String title;
  final String discription;
  final DateTime dateTime = DateTime.now();
  Notes({this.title = "", this.discription = "", super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Noteseditingpage(
                  title: this.title,
                  discription: this.discription,
                )));
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
    String toViewDiscribtion = discription;
    if (discription.length > 50) {
      int howMuchLetterToView = (discription.length * 0.20).round();
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
    String dateTimeString = DateFormat("yyyy-mm-dd - kk:mm").format(dateTime);
    return Container(
        margin: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
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
