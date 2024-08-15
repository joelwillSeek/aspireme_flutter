import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/Providers/FolderProvider.dart';
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
                  : individualNavigationItems(index)),
    );
  }

  Widget individualNavigationItems(int index) {
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
            navButtonClicked(index);
          },
          icon: Image.asset(chooseImage()),
        ));
  }

  Widget showCreateFolderDialog(BuildContext context) {
    TextEditingController folderNameInputText = TextEditingController();

    return SimpleDialog(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: folderNameInputText,
                decoration: const InputDecoration(
                    hintText: "Folder Name",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
            ),
            Column(
              children: [
                TextButton(
                    onPressed: () {
                      if (folderNameInputText.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                          "Please Enter A Name For Your Folder",
                          style: TextStyle(color: Colors.white),
                        )));
                      } else {
                        context.read<Folderprovider>().setAllFolders =
                            Folder(name: folderNameInputText.text.trim());
                      }
                    },
                    style: const ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(Colors.white)),
                    child: const Text("Yes")),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: const ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white)),
                  child: const Text("No"),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  void navButtonClicked(int index) {
    final itemIndex = index;
    final getPageControllerProvider = context.read<Pagecontrollerprovider>();

    if (index == 1) {
      showDialog(
          context: context,
          builder: (BuildContext context) => showCreateFolderDialog(context));
    }

    setState(() {
      getPageControllerProvider.setPageIndex = itemIndex;
      getPageControllerProvider.changePage(itemIndex, context);
    });
  }
}
