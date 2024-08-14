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

  void flashcard(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        alignment: Alignment.center,
        backgroundColor: Theme.of(context).colorScheme.surface,
        children: [
          Container(
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
          ),
          const Align(
            alignment: Alignment.center,
            child: Expanded(
                child: Text(
              "Title",
              style: TextStyle(color: Colors.white, fontSize: 50.0),
              textAlign: TextAlign.center,
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
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
            ),
          )
        ],
      ),
    );
  }

  flashcardButton(BuildContext context) {
    return Expanded(
      child: Center(
          child: Pulsator(
              style: PulseStyle(color: Theme.of(context).colorScheme.surface),
              count: 2,
              duration: const Duration(seconds: 4),
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
