import 'package:aspireme_flutter/Pages/Components/FolderWidget.dart';
import 'package:aspireme_flutter/Pages/Components/NotesWidget.dart';
import 'package:aspireme_flutter/Providers/FolderAndNoteMangerProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FolderAndNoteListPage extends StatelessWidget {
  const FolderAndNoteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.surface),
          child: FutureBuilder(
            future: Future.wait([
              Provider.of<FolderAndNoteManagerProvider>(context)
                  .getCurrentlySelectedSubFolders,
              Provider.of<FolderAndNoteManagerProvider>(context)
                  .getCurrentlySelectedSubNotes
            ]),
            builder: noteAndFolderFutureBuilder,
          ),
        ));
  }

  Widget noteAndFolderFutureBuilder(
      BuildContext context, AsyncSnapshot<List?> snapShot) {
    if (snapShot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapShot.hasError) {
      return Center(
          child: Text(
        'Grid Error: ${snapShot.error}',
        style: const TextStyle(color: Colors.red),
      ));
    }

    if (!snapShot.hasData || snapShot.data!.isEmpty) {
      return const Center(
          child: Text(
        'No Folders Or Notes Available',
        style: TextStyle(color: Colors.white),
      ));
    }

    final subFolders = snapShot.data![0];
    final subNotes = snapShot.data![1];
    return gridViewOfFolderAndNote(context, subFolders, subNotes);
  }

  Widget gridViewOfFolderAndNote(
      BuildContext context, List subFolders, List subNotes) {
    Widget folderNoteGrid() {
      final items = <Widget>[];

      items.addAll(subFolders
          .map((element) => GridTile(child: FolderWidget(folder: element))));
      items.addAll(subNotes
          .map((element) => GridTile(child: NotesWidget(note: element))));

      return GridView.count(
        crossAxisCount: 3,
        children: items,
      );
    }

    return PopScope(
        onPopInvoked: (didPop) async {
          if (didPop) return;
          print("pr");
          final closedTheFolder = await context
              .read<FolderAndNoteManagerProvider>()
              .closedFolder(context);

          if (!closedTheFolder) {
            SystemNavigator.pop();
          }
        },
        canPop: false,
        child: folderNoteGrid());
  }
}
