import 'package:aspireme_flutter/Pages/Home%20Page/Parts/FlashCard.dart';
import 'package:aspireme_flutter/Providers/Datastructure/DirectoryStrucutreManagerProvider.dart';
import 'package:aspireme_flutter/Providers/UI/FlashCardProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pulsator/pulsator.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          onWillPop(didPop, context);
        },
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

  void onWillPop(didPop, BuildContext context) async {
    if (didPop) return;

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App?'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(
              'Yes',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }

  void flashcard(BuildContext context) {
    showDialog(
        context: context, builder: (BuildContext context) => const FlashCard());
  }

  flashcardButton(BuildContext context) {
    return Expanded(
      child: Center(
          child: Pulsator(
              style: PulseStyle(color: Theme.of(context).colorScheme.secondary),
              count: 1,
              duration: const Duration(seconds: 2),
              repeat: 0,
              startFromScratch: true,
              autoStart: true,
              fit: PulseFit.contain,
              child: GestureDetector(
                  onTap: () async {
                    try {
                      await context
                          .read<DirectoryStructureManagerProvider>()
                          .resetStructure();

                      if (context.mounted) {
                        context.read<FlashCardProvider>().setShowDescription =
                            false;
                        flashcard(context);
                      }
                    } catch (e) {
                      debugPrint("Home Page flashcard button click : $e");
                    }
                  },
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        color: Theme.of(context).colorScheme.secondary),
                    child: Image.asset(
                      "asset/button/just_flashcard_icon.png",
                      scale: 1.2,
                    ),
                  )))),
    );
  }
}
