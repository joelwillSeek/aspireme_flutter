import 'package:aspireme_flutter/BackEnd/Database/SqlDatabase.dart';
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
  @override
  Widget build(BuildContext context) {
    int indexNavBar = Provider.of<Pagecontrollerprovider>(context).getPageIndex;

    return BottomNavigationBar(
        currentIndex: indexNavBar,
        onTap: (index) async {
          // setState(() {
          //   context.read<Pagecontrollerprovider>().setPageIndex = index;
          // });

          print("Folder table");
          await Sqldatabse.getFoldersWithCustomQuery();
          print("Note table");
          await Sqldatabse.getNotesWithCustomQuery();
          debugPrint("Document table");
          await Sqldatabse.getDocumentsWithCustomQuery();

          context.read<Pagecontrollerprovider>().goNextPage(index, context);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.folder,
              ),
              label: "Folder List"),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: "Settings",
          ),
        ]);
  }
}
