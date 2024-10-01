import 'package:aspireme_flutter/BackEnd/Database/sql_document_funciton.dart';
import 'package:aspireme_flutter/BackEnd/Models/document_model.dart';
import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/Pages/Document%20Editing%20View/document_editing_page.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
import 'package:aspireme_flutter/Providers/Datastructure/directory_strucutre_provider.dart';
import 'package:aspireme_flutter/Providers/UI/DocumentEditingPageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentWidget extends StatefulWidget {
  final DocumentModel documentModel;

  const DocumentWidget({required this.documentModel, super.key});

  @override
  State<DocumentWidget> createState() => _DocumentWidgetState();
}

class _DocumentWidgetState extends State<DocumentWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () {
          longPressClicked(context);
        },
        onTap: () {
          doucmentWidgetTapped(context);
        },
        child: Draggable(
            data: widget.documentModel,
            childWhenDragging: const DragedDocumentWidget(
              staying: true,
            ),
            feedback: const DragedDocumentWidget(),
            child: documentCard()));
  }

  void doucmentWidgetTapped(BuildContext context) async {
    try {
      showDialog(context: context, builder: (context) => const LoadingWidget());

      final updatedDocument =
          await Sqldocumentfunciton.getDocument(widget.documentModel.getId);

      if (context.mounted) {
        context.read<DocumentEditingPageProvider>().setBeingViewedDocument =
            updatedDocument!;
      }
    } catch (e) {
      debugPrint("Docuent Widget seting document view : $e");
    } finally {
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const DocumentEditingPage()));
      }
    }
  }

  Future<String?> showDeleteMenu(BuildContext context, Offset widgetPosition,
      Size widgetSize, RenderBox overlay) {
    return showMenu(
        color: Theme.of(context).colorScheme.secondary,
        context: context,
        position: calcuateItemPositon(widgetPosition, widgetSize, overlay),
        items: [
          PopupMenuItem(
            onTap: () async {
              await deleteItemTapped(context);
            },
            value: 'Option 1',
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onError),
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
              try {
                showDialog(
                    context: context,
                    builder: (context) => const LoadingWidget());

                await context
                    .read<DirectoryStructureManagerProvider>()
                    .shiftDocumentFolderToFolder(
                        widget.documentModel, shown[index]?.id ?? 0);

                print("go there");
              } catch (e) {
                debugPrint("Document widget move to new folder: $e");
              } finally {
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              }
            },
            child: Text(
              "move",
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ))
      ],
    );
  }

  Future<void> deleteItemTapped(BuildContext context) async {
    showDialog(context: context, builder: (context) => const LoadingWidget());
    await context
        .read<DirectoryStructureManagerProvider>()
        .deleteDocument(widget.documentModel);

    if (context.mounted) Navigator.pop(context);
  }

  RelativeRect calcuateItemPositon(
      Offset widgetPosition, Size widgetSize, RenderBox overlay) {
    return RelativeRect.fromLTRB(
      widgetPosition.dx +
          widgetSize.width, // Slightly to the right of the widget
      widgetPosition.dy, // Align vertically with the widget
      overlay.size.width -
          widgetPosition.dx -
          widgetSize.width, // Remaining space on the right
      overlay.size.height - widgetPosition.dy, // Remaining space at the bottom
    );
  }

  Widget documentCard() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "asset/Icons/document_icon.png",
            scale: 1.4,
          ),
          Text(
            widget.documentModel.getName,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  void longPressClicked(BuildContext context) {
    final RenderBox widgetBox = context.findRenderObject() as RenderBox;
    final Offset widgetPosition = widgetBox.localToGlobal(Offset.zero);
    final Size widgetSize = widgetBox.size;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showDeleteMenu(context, widgetPosition, widgetSize, overlay);
  }
}

class DragedDocumentWidget extends StatelessWidget {
  final bool staying;
  const DragedDocumentWidget({this.staying = false, super.key});

  @override
  Widget build(BuildContext context) {
    return staying ? Opacity(opacity: 0.5, child: Thecard()) : Thecard();
  }

  Card Thecard() {
    return Card(
      elevation: 0.0,
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Image.asset("asset/Icons/document_icon.png")],
      ),
    );
  }
}
