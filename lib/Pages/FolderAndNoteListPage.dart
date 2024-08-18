import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/SqlDatabase.dart';
import 'package:aspireme_flutter/CommonllyUsedComponents/FolderWidget.dart';
import 'package:aspireme_flutter/CommonllyUsedComponents/NotesWidget.dart';
import 'package:aspireme_flutter/Providers/FolderAndNoteProvider.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderAndNoteListPage extends StatelessWidget {
  FolderAndNoteListPage({super.key});

  Future<List<Object>> convertDataToFolderAndNote(BuildContext context) async {
    final allDataFolders =
        await Provider.of<FolderAndNoteProvider>(context, listen: false)
            .getAllFolders;
    final allDataNotes =
        await Provider.of<FolderAndNoteProvider>(context, listen: false)
            .getNotesOfFolder(context);

    final bothData = [...allDataFolders, ...allDataNotes];

    return bothData;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.surface),
          child: FutureBuilder(
              future: convertDataToFolderAndNote(
                  context), // Ensure this is a Future
              builder: noteAndFolderFutureBuilder)),
    );
  }

  Widget noteAndFolderFutureBuilder(
      BuildContext context, AsyncSnapshot<List<Object>> snapShot) {
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

    final item = snapShot.data!;
    return gridViewOfFolderAndNote(item);
  }

  Widget gridViewOfFolderAndNote(List<Object> item) {
    return GridView.builder(
      itemCount: item.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        final individualItem = item[index];
        if (individualItem is Folder) {
          return FolderWidget(folder: individualItem as Folder);
        }

        if (individualItem is Note) {
          return NotesWidget(note: individualItem as Note);
        }

        return const Text(
          "Empty",
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }
}
