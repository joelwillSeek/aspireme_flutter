import 'package:aspireme_flutter/BackEnd/Database/SqlDocumentFunciton.dart';
import 'package:aspireme_flutter/BackEnd/Models/DocumentModel.dart';
import 'package:aspireme_flutter/Pages/Document%20Editing%20View/DocumentEditingPage.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
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

      showDeleteMenu(context, widgetPosition, widgetSize, overlay);
    }

    void onTap() async {
      try {
        showDialog(
            context: context, builder: (context) => const LoadingWidget());

        final updatedDocument =
            await Sqldocumentfunciton.getDocument(documentModel.getId);

        context.read<DocumentEditingPageProvider>().setBeingViewedDocument =
            updatedDocument!;
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

    Widget documentCard() {
      return Card(
        elevation: 0.0,
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
      );
    }

    return GestureDetector(
        onLongPress: longPressClicked,
        onTap: onTap,
        child: Draggable(
            data: documentModel,
            childWhenDragging: const DragedDocumentWidget(
              staying: true,
            ),
            feedback: const DragedDocumentWidget(),
            child: documentCard()));
  }

  Future<String?> showDeleteMenu(BuildContext context, Offset widgetPosition,
      Size widgetSize, RenderBox overlay) {
    return showMenu(
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
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) => const LoadingWidget());
              await context
                  .read<DirectoryStructureManagerProvider>()
                  .deleteDocument(documentModel);

              if (context.mounted) Navigator.pop(context);
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
        ]);
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
