import 'package:aspireme_flutter/Pages/Home%20Page/Parts/FlashCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulsator/pulsator.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    void onWillPop(didPop) async {
      if (didPop) return;
      debugPrint("joo");

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit App?'),
          content: const Text('Do you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }

    return PopScope(
        canPop: false,
        onPopInvoked: onWillPop,
        child: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.surface),
          child: Column(
            children: [
              flashcardButton(context),
            ],
          ),
        ));
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
