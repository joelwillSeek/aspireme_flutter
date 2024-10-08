import 'package:aspireme_flutter/Pages/Home%20Page/Parts/FlashCard.dart';
import 'package:aspireme_flutter/Providers/Datastructure/directory_strucutre_provider.dart';
import 'package:aspireme_flutter/Providers/UI/FlashCardProvider.dart';
import 'package:aspireme_flutter/Providers/Tutorial/tutorial_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pulsator/pulsator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<void> doOrNotTutorial() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final homeTutorial = prefs.getBool("showHomeTutorial");

    if ((homeTutorial == null || homeTutorial == true) && context.mounted) {
      final tutorialProvider = context.read<TutorialProvider>();
      tutorialProvider.createTutorialHome(context);
      tutorialProvider.showTutorial(context);
    }
  }

  @override
  void initState() {
    super.initState();

    doOrNotTutorial();
  }

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
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlashCardFAB(),
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
}

class FlashCardFAB extends StatelessWidget {
  const FlashCardFAB({super.key});

  void flashcard(BuildContext context) {
    showDialog(
        context: context, builder: (BuildContext context) => const FlashCard());
  }

  Future<void> flashcardClicked(BuildContext context) async {
    try {
      await context.read<DirectoryStructureManagerProvider>().resetStructure();

      if (context.mounted) {
        context.read<FlashCardProvider>().setShowDescription = false;

        flashcard(context);
      }
    } catch (e) {
      debugPrint("Home Page flashcard button click : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
          child: Pulsator(
              style: PulseStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
              count: 1,
              duration: const Duration(seconds: 2),
              repeat: 0,
              startFromScratch: true,
              autoStart: true,
              fit: PulseFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      key: context.read<TutorialProvider>().flashCardKey,
                      onTap: () async {
                        await flashcardClicked(context);
                      },
                      child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              color: Theme.of(context).colorScheme.secondary),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "asset/button/just_flashcard_icon.png",
                                scale: 1.2,
                              ),
                              Text("Memorize",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary)),
                            ],
                          ))),
                ],
              ))),
    );
  }
}
