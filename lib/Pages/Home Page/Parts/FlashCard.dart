import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/Providers/FlashCardProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashCard extends StatelessWidget {
  const FlashCard({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      await context.read<FlashCardProvider>().getAllWrongNotes(context);
    });

    return SimpleDialog(
      shadowColor: const Color.fromARGB(255, 0, 0, 0),
      alignment: Alignment.center,
      backgroundColor: Theme.of(context).colorScheme.surface,
      children: [
        closeButton(context),
        noteTitleOrDescription(context),
        rememberedOrNotButtons(context)
      ],
    );
  }

  Widget rememberedOrNotButtons(BuildContext context) {
    //added a null check to the function that calls this
    Note? note = Provider.of<FlashCardProvider>(context).getNoteToShow();
    Widget yesOrNoButtons(Note notNullNote) {
      void didntRemember() {
        final flashCardManager = context.read<FlashCardProvider>();

        flashCardManager.addToWrong(note!);
      }

      void didRemember() {
        final flashCardManager = context.read<FlashCardProvider>();

        flashCardManager.setCorrectNote(note!);
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              onPressed: didntRemember,
              icon: Image.asset(
                "asset/button/cancel_hover.png",
                scale: 3,
              )),
          IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              onPressed: didRemember,
              icon: Image.asset(
                "asset/button/done_hover.png",
                scale: 3,
              ))
        ],
      );
    }

    Widget seeMoreButton() {
      void remembered() {
        Provider.of<FlashCardProvider>(context, listen: false)
            .setShowDescription = true;
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
              padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0)),
            ),
            onPressed: remembered,
            child: const Text(
              "See",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    }

    return note == null
        ? const Placeholder(
            color: Colors.transparent,
            fallbackHeight: 80.0,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Provider.of<FlashCardProvider>(context).getShowDescription
                ? yesOrNoButtons(note)
                : seeMoreButton());
  }

  Widget closeButton(BuildContext context) {
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

  Widget noteTitleOrDescription(BuildContext context) {
    Note? note = Provider.of<FlashCardProvider>(context).getNoteToShow();

    Widget title() {
      return Expanded(
          child: Text(
        note == null ? "No notes found" : note.title,
        style: const TextStyle(color: Colors.white, fontSize: 50.0),
        textAlign: TextAlign.center,
      ));
    }

    Widget description() {
      return Expanded(
          child: Text(
        note!.description,
        style: const TextStyle(color: Colors.white, fontSize: 50.0),
        textAlign: TextAlign.center,
      ));
    }

    return Align(
        alignment: Alignment.center,
        child: Provider.of<FlashCardProvider>(context).getShowDescription
            ? description()
            : title());
  }
}
