import 'package:aspireme_flutter/BackEnd/Models/DocumentModel.dart';
import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/Providers/DirectoryStrucutreManagerProvider.dart';
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
                    .read<DirectoryStructureManagerProvider>()
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
      context.read<DirectoryStructureManagerProvider>().openFolder = folder;
      context.read<Pagecontrollerprovider>().goNextPage(1, context);
    }

    Widget folderWidget() {
      return Column(
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
                softWrap: false,
              )),
        ],
      );
    }

    return Draggable(
        data: folder,
        childWhenDragging: const FolderWidgetDragging(
          shadow: true,
        ),
        feedback: const FolderWidgetDragging(),
        child: GestureDetector(
            onLongPress: longPressClicked,
            onTap: folderClicked,
            child: DragTarget(
                onAcceptWithDetails: (dataDetails) {
                  onAcceptWithDetails(dataDetails.data, context);
                },
                builder: (context, candidateData, rejectionData) =>
                    folderWidget())));
  }

  Future<void> onAcceptWithDetails(Object? data, BuildContext context) async {
    try {
      if (data == null) {
        throw Exception("data passed when droped is null");
      }

      if (folder.id == null) {
        throw Exception("folder id null in folderWidget dragTarget");
      }

      if (data is Folder) {
        await context
            .read<DirectoryStructureManagerProvider>()
            .shiftFolderFromFolderToNewFolder(data, folder.id!);
        return;
      }

      if (data is DocumentModel) {
        await context
            .read<DirectoryStructureManagerProvider>()
            .shiftDocumentFolderToFolder(data, folder.id!);
        return;
      }
    } catch (e) {
      debugPrint("Folder Widget drag target : $e");
    }
  }
}

class FolderWidgetDragging extends StatelessWidget {
  final bool shadow;
  const FolderWidgetDragging({this.shadow = false, super.key});

  @override
  Widget build(BuildContext context) {
    return shadow
        ? Opacity(
            opacity: 0.5,
            child: Column(
              children: [
                IconButton(
                    onPressed: null,
                    iconSize: 10.0,
                    icon: Image.asset("asset/Icons/folder_icon.png")),
              ],
            ),
          )
        : Column(
            children: [
              IconButton(
                  onPressed: null,
                  iconSize: 10.0,
                  icon: Image.asset("asset/Icons/folder_icon.png")),
            ],
          );
  }
}
