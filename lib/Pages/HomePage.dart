import 'package:aspireme_flutter/Pages/Components/FlashCard.dart';
import 'package:flutter/material.dart';
import 'package:pulsator/pulsator.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Column(
        children: [
          flashcardButton(context),
        ],
      ),
    );
  }

  flashcardButton(BuildContext context) {
    void flashcard(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const FlashCard());
    }

    return Expanded(
      child: Center(
          child: Pulsator(
              style: PulseStyle(color: Theme.of(context).colorScheme.primary),
              count: 1,
              duration: const Duration(seconds: 2),
              repeat: 0,
              startFromScratch: true,
              autoStart: true,
              fit: PulseFit.contain,
              child: GestureDetector(
                onTap: () {
                  flashcard(context);
                },
                child: Image.asset(
                  "asset/button/task_hover.png",
                  scale: 1.2,
                ),
              ))),
    );
  }
}
