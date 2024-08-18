import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/Providers/FolderAndNoteProvider.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderWidget extends StatelessWidget {
  Folder folder;
  FolderWidget({required this.folder, super.key});

  @override
  Widget build(BuildContext context) {
    void folderClicked() {
      context.read<FolderAndNoteProvider>().setCurrentlySelectedFolder =
          folder.id;
      context.read<Pagecontrollerprovider>().changePage(2, context);
      print("folder id " + folder.id.toString());
    }

    return Column(
      children: [
        IconButton(
            onPressed: folderClicked,
            iconSize: 10.0,
            icon: Image.asset("asset/Icons/folder_icon.png")),
        SizedBox(
            width: 100.0,
            height: 40.0,
            child: Text(
              folder.name ?? "Empty",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              softWrap: false,
            )),
      ],
    );
  }
}
