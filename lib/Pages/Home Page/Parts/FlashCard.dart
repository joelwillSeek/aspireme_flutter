import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/Providers/UI/FlashCardProvider.dart';
import 'package:aspireme_flutter/Providers/UI/theme_provider.dart';
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
      alignment: Alignment.center,
      backgroundColor: Theme.of(context).colorScheme.surface,
      children: [
        closeButton(context),
        noteTitleOrDescription(context),
        rememberedOrNotButtons(context)
      ],
    );
  }

  void didntRemember(BuildContext context, Note note) {
    final flashCardManager = context.read<FlashCardProvider>();

    flashCardManager.addToWrong(note);
  }

  void didRemember(BuildContext context, Note note) {
    final flashCardManager = context.read<FlashCardProvider>();

    flashCardManager.setCorrectNote(note);
  }

  Widget yesOrNoButtons(Note note, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            style: ButtonStyle(
                shape: const WidgetStatePropertyAll(CircleBorder()),
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.secondary)),
            onPressed: () {
              didRemember(context, note);
            },
            child: Image.asset(
              Provider.of<ThemeProvider>(context).isDarkMode(context)
                  ? "asset/button/done_black.png"
                  : "asset/button/done.png",
              scale: 2,
            )),
        IconButton(
            style: ButtonStyle(
                shape: const WidgetStatePropertyAll(CircleBorder()),
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.secondary)),
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            onPressed: () {
              didntRemember(context, note);
            },
            icon: Image.asset(
              Provider.of<ThemeProvider>(context).isDarkMode(context)
                  ? "asset/button/wrong_black.png"
                  : "asset/button/wrong.png",
              scale: 2,
            ))
      ],
    );
  }

  Widget seeMoreButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
            padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0)),
          ),
          onPressed: () {
            context.read<FlashCardProvider>().setShowDescription = true;
          },
          child: const Text(
            "See",
          ),
        ),
      ],
    );
  }

  Widget rememberedOrNotButtons(BuildContext context) {
    //added a null check to the function that calls this
    Note? note = Provider.of<FlashCardProvider>(context).getNoteToShow();

    return note == null
        ? const Placeholder(
            color: Colors.transparent,
            fallbackHeight: 80.0,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Provider.of<FlashCardProvider>(context).getShowDescription
                ? yesOrNoButtons(note, context)
                : seeMoreButton(context));
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
            Provider.of<ThemeProvider>(context).isDarkMode(context)
                ? "asset/button/wrong.png"
                : "asset/button/wrong_black.png",
            scale: 2,
            alignment: Alignment.centerRight,
          )),
    );
  }

  Widget title(Note? note) {
    return Text(
      note == null ? "No more notes" : note.title,
      style: const TextStyle(fontSize: 30.0),
      textAlign: TextAlign.center,
    );
  }

  Widget description(Note? note) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Text(
        note!.description,
        style: const TextStyle(fontSize: 20.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget noteTitleOrDescription(BuildContext context) {
    Note? note = Provider.of<FlashCardProvider>(context).getNoteToShow();

    return Align(
        alignment: Alignment.center,
        child: Provider.of<FlashCardProvider>(context).getShowDescription
            ? description(note)
            : title(note));
  }
}
