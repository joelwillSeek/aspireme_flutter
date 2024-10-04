import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

Widget info(String value) {
  return IgnorePointer(
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 20.0),
          )
        ]),
  );
}

List<TargetFocus> homePageTargets(
    {required GlobalKey flashCardkey,
    required GlobalKey bottomNavBar,
    required GlobalKey syncButton,
    required GlobalKey backButton,
    required BuildContext context}) {
  List<TargetFocus> targets = [];

  targets.add(TargetFocus(
      enableOverlayTab: true,
      keyTarget: flashCardkey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.Circle,
      color: Colors.blue[800],
      // color: Theme.of(context).colorScheme.secondary,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, tourController) => info(
                  "Click the button to view all you notes as flashcard, Wrong notes will be viewed first",
                ))
      ]));

  targets.add(TargetFocus(
      enableOverlayTab: true,
      keyTarget: syncButton,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.Circle,
      color: Colors.blue[800],
      // color: Theme.of(context).colorScheme.secondary,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, tourController) => info(
                "You can use a sync with firebase or export to your choice of folder"))
      ]));

  targets.add(TargetFocus(
      enableOverlayTab: true,
      keyTarget: backButton,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.Circle,
      color: Colors.blue[800],
      // color: Theme.of(context).colorScheme.secondary,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, tourController) => info(
                "back button to go back. Your suppose to know this already"))
      ]));

  targets.add(TargetFocus(
      enableOverlayTab: true,
      keyTarget: bottomNavBar,
      alignSkip: Alignment.topCenter,
      radius: 2,
      shape: ShapeLightFocus.RRect,
      color: Colors.blue[800],
      // color: Theme.of(context).colorScheme.secondary,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            builder: (context, tourController) => info(
                  "Use this to navigate the pages or just swipe the screen",
                ))
      ]));

  return targets;
}

List<TargetFocus> folderPageTargets(
    {required GlobalKey typeButtonKey, required GlobalKey addFABKey}) {
  List<TargetFocus> targets = [];

  targets.add(TargetFocus(
      enableOverlayTab: true,
      keyTarget: typeButtonKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      color: Colors.blue[800],
      // color: Theme.of(context).colorScheme.secondary,
      contents: [
        TargetContent(
            align: ContentAlign.bottom,
            builder: (context, tourController) => Column(
                  children: [
                    info(
                      "You can change how the folders and documents are sort",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Image.asset("asset/Icons/folder_icon.png"),
                            const Text(
                              "Folder",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Image.asset("asset/Icons/document_icon.png"),
                            const Text(
                              "Document",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ))
      ]));

  targets.add(TargetFocus(
      enableOverlayTab: true,
      keyTarget: addFABKey,
      alignSkip: Alignment.bottomRight,
      radius: 10,
      shape: ShapeLightFocus.Circle,
      color: Colors.blue[800],
      // color: Theme.of(context).colorScheme.secondary,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            builder: (context, tourController) => info(
                  "Click here to open a dialog box that has a tab for both document and folder creation.",
                )),
      ]));

  return targets;
}
