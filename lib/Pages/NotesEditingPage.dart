import 'package:aspireme_flutter/Pages/Components/CustomTopAppBar.dart';
import 'package:flutter/material.dart';

class Noteseditingpage extends StatelessWidget {
  String title;
  String discription;
  Noteseditingpage({this.discription = "", this.title = "", super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Customtopappbar(),
      ),
      body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              cardForEditing(context),
              confirmOrCancelButtons(context)
            ],
          )),
    );
  }

  Widget confirmOrCancelButtons(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: null,
            style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.onTertiary),
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.tertiary)),
            child: const Text("Save")),
        TextButton(
            style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.onError),
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.error)),
            onPressed: null,
            child: const Text("Cancel")),
      ],
    );
  }

  Widget cardForEditing(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              alignment: Alignment.center,
              child: Center(
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                      background: Paint()
                        ..color = const Color.fromARGB(255, 200, 200, 200)),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      border: InputBorder.none,
                      labelText: title,
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary)),
                ),
              )),
          TextField(
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: discription,
              border: InputBorder.none,
              labelStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ),
          )
        ],
      ),
    );
  }
}
