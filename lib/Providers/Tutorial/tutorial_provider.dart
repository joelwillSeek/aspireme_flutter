import 'dart:ui';
import 'package:aspireme_flutter/Providers/Tutorial/tour_targets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialProvider extends ChangeNotifier {
  late TutorialCoachMark tutorialCoachMark;

  final flashCardKey = GlobalKey();
  final syncNavButton = GlobalKey();
  final backNavButton = GlobalKey();
  final bottomNavBar = GlobalKey();
  final floatingActionButton = GlobalKey();
  final addFloadingActionButton = GlobalKey();
  final typeButtonKey = GlobalKey();

  void createTutorialHome(
    BuildContext context,
  ) {
    try {
      if (context.mounted) {
        tutorialCoachMarkSetup(
            homePageTargets(
                flashCardkey: flashCardKey,
                bottomNavBar: bottomNavBar,
                syncButton: syncNavButton,
                backButton: backNavButton,
                context: context),
            isHomePageTutorial: true);
      }
    } catch (e) {
      debugPrint("createTutorialHome : $e");
    }
  }

  void tutorialCoachMarkSetup(List<TargetFocus> targets,
      {bool isHomePageTutorial = false, bool isFolderPageTutorial = false}) {
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        if (isHomePageTutorial) {
          prefs.setBool("showHomeTutorial", false);
          return;
        }

        if (isFolderPageTutorial) {
          prefs.setBool("showFolderTutorial", false);
          return;
        }
      },
    );
  }

  void createTutorialFolder(BuildContext context) {
    tutorialCoachMarkSetup(
        folderPageTargets(
            typeButtonKey: typeButtonKey, addFABKey: addFloadingActionButton),
        isFolderPageTutorial: true);
  }

  void showTutorial(BuildContext context) {
    Future.delayed(const Duration(microseconds: 500),
        () => tutorialCoachMark.show(context: context));
  }
}
