import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/Providers/FolderAndNoteMangerProvider.dart';
//import 'package:aspireme_flutter/Providers/FolderAndNoteProvider.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderWidget extends StatelessWidget {
  final Folder folder;
  const FolderWidget({required this.folder, super.key});

  @override
  Widget build(BuildContext context) {
    void longPressClicked() {
      final RenderBox widgetBox = context.findRenderObject() as RenderBox;
      final Offset widgetPosition = widgetBox.localToGlobal(Offset.zero);
      final Size widgetSize = widgetBox.size;

      final RenderBox overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;

      showMenu(
          color: Theme.of(context).colorScheme.secondary,
          context: context,
          position: RelativeRect.fromLTRB(
            widgetPosition.dx +
                widgetSize.width, // Slightly to the right of the widget
            widgetPosition.dy, // Align vertically with the widget
            overlay.size.width -
                widgetPosition.dx -
                widgetSize.width, // Remaining space on the right
            overlay.size.height -
                widgetPosition.dy, // Remaining space at the bottom
          ),
          items: [
            PopupMenuItem(
              onTap: () {
                context
                    .read<FolderAndNoteManagerProvider>()
                    .deleteFolder(folder);
              },
              value: 'Option 1',
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ]);
    }

    void folderClicked() {
      context.read<FolderAndNoteManagerProvider>().openFolder = folder;
      context.read<Pagecontrollerprovider>().changePage(2, context);
    }

    return GestureDetector(
      onLongPress: longPressClicked,
      onTap: folderClicked,
      child: Column(
        children: [
          IconButton(
              onPressed: null,
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
      ),
    );
  }
}
