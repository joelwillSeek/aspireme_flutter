import 'package:aspireme_flutter/BackEnd/Models/DocumentModel.dart';
import 'package:aspireme_flutter/Pages/Document%20Editing%20View/DocumentEditingPage.dart';
import 'package:aspireme_flutter/Providers/DirectoryStrucutreManagerProvider.dart';
import 'package:aspireme_flutter/Providers/DocumentEditingPageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentWidget extends StatelessWidget {
  final DocumentModel documentModel;

  const DocumentWidget({required this.documentModel, super.key});

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
                    .deleteDocument(documentModel);
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

    return GestureDetector(
      onLongPress: longPressClicked,
      onTap: () {
        context.read<DocumentEditingPageProvider>().setBeingViewedDocument =
            documentModel;

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DocumentEditingPage()));
      },
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("asset/Icons/document_icon.png"),
            Text(
              documentModel.getName,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
