import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
import 'package:aspireme_flutter/Providers/DirectoryStrucutreManagerProvider.dart';
//import 'package:aspireme_flutter/Providers/FolderAndNoteProvider.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FloatingBottomNav extends StatefulWidget {
  const FloatingBottomNav({super.key});

  @override
  State<FloatingBottomNav> createState() => _FloatingBottomNavState();
}

class _FloatingBottomNavState extends State<FloatingBottomNav> {
  final List navIcons = [
    "asset/button/home.png",
    "asset/button/add.png",
    "asset/button/folder.png"
  ];

  final List navIconsSelected = [
    "asset/button/home_hover.png",
    "asset/button/add_hover.png",
    "asset/button/folder_hover.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(500.0)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.surface,
                offset: const Offset(0, 0),
                blurRadius: 20.0)
          ]),
      child: itemBuilder(context),
    );
  }

  Widget itemBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
          navIcons.length,
          (index) =>
              Provider.of<Pagecontrollerprovider>(context).getPageIndex == 0 &&
                      index == 1
                  ? const Placeholder(
                      fallbackWidth: 100,
                      color: Colors.transparent,
                    )
                  : individualNavigationItems(index, context)),
    );
  }

  Widget individualNavigationItems(int index, BuildContext context) {
    String chooseImage() {
      final pageControllerProvidor = context.read<Pagecontrollerprovider>();
      if (pageControllerProvidor.getPageIndex == 0 && index == 0) {
        return navIconsSelected[index];
      } else if (pageControllerProvidor.getPageIndex == 1 && index == 2) {
        return navIconsSelected[index];
      } else {
        return navIcons[index];
      }
    }

    return SizedBox(
        width: 50,
        height: 50,
        child: IconButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            navButtonClicked(index, context);
          },
          icon: Image.asset(chooseImage()),
        ));
  }

  Widget createFolderTab(BuildContext context) {
    TextEditingController folderNameInputText = TextEditingController();

    Future<void> yesClicked() async {
      if (folderNameInputText.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Please Enter A Name For Your Folder",
          style: TextStyle(color: Colors.white),
        )));
      } else {
        final folderAndNoteProvider =
            context.read<DirectoryStructureManagerProvider>();
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => const LoadingWidget());
        await folderAndNoteProvider.addFolder(folderNameInputText.text);
        if (context.mounted) {
          Navigator.pop(context);
        }
      }

      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    return Column(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: TextField(
                controller: folderNameInputText,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Folder Name",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: TextButton(
                        onPressed: yesClicked,
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.tertiary)),
                        child: Text("Done",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiary)))),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.error)),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onError),
                    ),
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  Widget createDocumentTab(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    Future<void> doneClicked() async {
      if (textEditingController.text.length > 1) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => const LoadingWidget());

        await context
            .read<DirectoryStructureManagerProvider>()
            .addDocument(textEditingController.text);

        if (context.mounted) {
          Navigator.pop(context);

          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Make sure you enter at least one letter")));
      }
    }

    return Column(
      children: [
        Expanded(
          child: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Chemistry...",
                hintStyle: TextStyle(color: Colors.white)),
          ),
        ),
        Row(
          children: [
            Expanded(
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.tertiary)),
                    onPressed: doneClicked,
                    child: Text(
                      "Done",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onTertiary),
                    ))),
            Expanded(
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.error)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onError),
                        "Cancel"))),
          ],
        )
      ],
    );
  }

  Widget createFolderOrDocumentDialog(BuildContext context) {
    return Dialog(
      child: SizedBox(
          height: 400,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: DefaultTabController(
                length: 2,
                child: Column(children: [
                  TabBar(
                    dividerColor: Theme.of(context).colorScheme.onPrimary,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor:
                        Theme.of(context).colorScheme.onPrimary,
                    tabs: const [
                      Tab(
                        text: "Folder",
                      ),
                      Tab(
                        text: "Document",
                      )
                    ],
                  ),
                  Expanded(
                      child: TabBarView(children: [
                    createFolderTab(context),
                    createDocumentTab(context)
                  ]))
                ])),
          )),
    );
  }

  void navButtonClicked(int indexOfNavItem, BuildContext context) {
    final itemIndex = indexOfNavItem;
    final pageControllerProvider = context.read<Pagecontrollerprovider>();
    /**
     * Todo: Don't want this hard coded index fix it 
     */
    if (indexOfNavItem == 1 &&
        pageControllerProvider.getCurrentPageName ==
            pageControllerProvider.getExitingPages[1]) {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              createFolderOrDocumentDialog(context));

      return;
    }

    setState(() {
      pageControllerProvider.setPageIndex = itemIndex;
      pageControllerProvider.changePage(itemIndex, context);
    });
  }
}
