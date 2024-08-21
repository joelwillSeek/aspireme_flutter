import 'package:aspireme_flutter/BackEnd/FlashCardAlgorithm.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/Providers/FlashCardProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FlashCard extends StatefulWidget {
  FlashCard({super.key});

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  bool showDescription = false;

  @override
  Widget build(BuildContext context) {
    Note noteToSee =
        Provider.of<FlashCardProvider>(context).getNoteToShow(context);
    return SimpleDialog(
      shadowColor: const Color.fromARGB(255, 0, 0, 0),
      alignment: Alignment.center,
      backgroundColor: Theme.of(context).colorScheme.surface,
      children: [
        closeButton(),
        noteTitleOrDiscription(noteToSee),
        rememberedOrNotButtons()
      ],
    );
  }

  Widget rememberedOrNotButtons() {
    void remebered() {
      setState(() {
        showDescription = true;
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: showDescription
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    onPressed: null,
                    icon: Image.asset(
                      "asset/button/cancel_hover.png",
                      scale: 3,
                    )),
                IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    onPressed: null,
                    icon: Image.asset(
                      "asset/button/done_hover.png",
                      scale: 3,
                    ))
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.primary),
                    padding: WidgetStatePropertyAll(EdgeInsets.all(20.0)),
                  ),
                  onPressed: () {
                    remebered();
                  },
                  child: const Text(
                    "See",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
    );
  }

  Widget closeButton() {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.all(20),
      child: IconButton(
          alignment: Alignment.topRight,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "asset/button/cancel.png",
            scale: 4,
            alignment: Alignment.centerRight,
          )),
    );
  }

  Widget noteTitleOrDiscription(Note note) {
    Widget title() {
      return Expanded(
          child: Text(
        note.title,
        style: const TextStyle(color: Colors.white, fontSize: 50.0),
        textAlign: TextAlign.center,
      ));
    }

    Widget description() {
      return Expanded(
          child: Text(
        note.description,
        style: const TextStyle(color: Colors.white, fontSize: 50.0),
        textAlign: TextAlign.center,
      ));
      ;
    }

    return Align(
        alignment: Alignment.center,
        child: showDescription ? description() : title());
  }
}
