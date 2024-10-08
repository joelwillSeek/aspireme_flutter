import 'package:aspireme_flutter/BackEnd/Models/document_model.dart';
import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
import 'package:aspireme_flutter/Providers/Datastructure/directory_strucutre_provider.dart';
//import 'package:aspireme_flutter/Providers/FolderAndNoteProvider.dart';
import 'package:aspireme_flutter/Providers/UI/PageControllerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderWidget extends StatefulWidget {
  final Folder folder;
  const FolderWidget({required this.folder, super.key});

  @override
  State<FolderWidget> createState() => _FolderWidgetState();
}

class _FolderWidgetState extends State<FolderWidget> {
  void folderClicked(BuildContext context) {
    context.read<DirectoryStructureManagerProvider>().openFolder =
        widget.folder;
    context.read<Pagecontrollerprovider>().goNextPage(1, context);
  }

  @override
  Widget build(BuildContext context) {
    return Draggable(
        data: widget.folder,
        childWhenDragging: const FolderWidgetDragging(
          shadow: true,
        ),
        feedback: const FolderWidgetDragging(),
        child: GestureDetector(
            onLongPress: () {
              longPressClicked(context);
            },
            onTap: () {
              folderClicked(context);
            },
            child: DragTarget(
                onAcceptWithDetails: (dataDetails) {
                  onAcceptWithDetails(dataDetails.data, context);
                },
                builder: (context, candidateData, rejectionData) =>
                    folderWidget())));
  }

  Widget folderWidget() {
    return Card(
        child: Column(
      children: [
        IconButton(
            onPressed: null,
            iconSize: 10.0,
            icon: Image.asset("asset/Icons/folder_icon.png")),
        SizedBox(
            width: 100.0,
            height: 30.0,
            child: Text(
              widget.folder.name ?? "Empty",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: false,
            )),
      ],
    ));
  }

  void longPressClicked(BuildContext context) {
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
                  .deleteFolder(widget.folder);
            },
            value: 'Option 1',
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
          PopupMenuItem(
            onTap: () async {
              await moveOptionTapped(context);
            },
            value: 'Option 1',
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 134, 243),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Move',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
          ),
        ]);
  }

  void searchBoxQueryChanged(
      String query, List<Folder?> shown, List<Folder>? allFolders) {
    if (query.isEmpty) {
      setState(() {
        shown = allFolders ?? [];
      });
    } else {
      setState(() {
        shown = allFolders
                ?.where((element) =>
                    element.name?.toLowerCase() == query.toLowerCase())
                .toList() ??
            [];
      });
    }
  }

  Future<void> moveOptionTapped(BuildContext context) async {
    final allFolders =
        await context.read<DirectoryStructureManagerProvider>().getAllFolders();
    List<Folder?> shown = allFolders ?? [];

    if (context.mounted) {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                child: Column(
                  children: [
                    SearchBar(
                      hintText: "Search ...",
                      onChanged: (query) {
                        searchBoxQueryChanged(query, shown, allFolders);
                      },
                    ),
                    SizedBox(
                      height: 400.0,
                      child: ListView.builder(
                        itemCount: shown.length,
                        itemBuilder: (context, index) =>
                            folderMoveIcon(shown, index),
                      ),
                    )
                  ],
                ),
              ));
    }
  }

  Row folderMoveIcon(List<Folder?> shown, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.folder),
        Text(shown[index]?.name ?? "Error"),
        TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.secondary)),
            onPressed: () async {
              await moveFolderClicked(shown, index);
            },
            child: Text(
              "move",
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ))
      ],
    );
  }

  Future<void> moveFolderClicked(List<Folder?> shown, int index) async {
    try {
      showDialog(context: context, builder: (context) => const LoadingWidget());

      await context
          .read<DirectoryStructureManagerProvider>()
          .shiftFolderFromFolderToNewFolder(
              widget.folder, shown[index]?.id ?? 0);
    } catch (e) {
      debugPrint("Document widget move to new folder: $e");
    } finally {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }

  Future<void> onAcceptWithDetails(Object? data, BuildContext context) async {
    try {
      if (data == null) {
        throw Exception("data passed when droped is null");
      }

      if (widget.folder.id == null) {
        throw Exception("folder id null in folderWidget dragTarget");
      }

      if (data is Folder) {
        await context
            .read<DirectoryStructureManagerProvider>()
            .shiftFolderFromFolderToNewFolder(data, widget.folder.id!);
        return;
      }

      if (data is DocumentModel) {
        await context
            .read<DirectoryStructureManagerProvider>()
            .shiftDocumentFolderToFolder(data, widget.folder.id!);
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
