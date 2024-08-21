import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
import 'package:aspireme_flutter/BackEnd/SqlDatabase.dart';
import 'package:aspireme_flutter/Pages/Components/FolderWidget.dart';
import 'package:aspireme_flutter/Pages/Components/NotesWidget.dart';
import 'package:aspireme_flutter/Providers/FolderAndNoteMangerProvider.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FolderAndNoteListPage extends StatelessWidget {
  FolderAndNoteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.surface),
          child: noteAndFolderFutureBuilder(context),
        ));
  }

  Widget noteAndFolderFutureBuilder(BuildContext context) {
    // if (snapShot.connectionState == ConnectionState.waiting) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    // if (snapShot.hasError) {
    //   return Center(
    //       child: Text(
    //     'Grid Error: ${snapShot.error}',
    //     style: const TextStyle(color: Colors.red),
    //   ));
    // }

    // if (!snapShot.hasData || snapShot.data!.isEmpty) {
    //   return const Center(
    //       child: Text(
    //     'No Folders Or Notes Available',
    //     style: TextStyle(color: Colors.white),
    //   ));
    // }

    // final item = snapShot.data!;
    return gridViewOfFolderAndNote(context);
  }

  Widget gridViewOfFolderAndNote(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) return;
        print("pr");
        final closedTheFolder =
            context.read<FolderAndNoteManagerProvider>().closedFolder(context);
        if (!closedTheFolder) {
          SystemNavigator.pop();
        }
      },
      canPop: false,
      child: GridView.builder(
        itemCount: Provider.of<FolderAndNoteManagerProvider>(context)
            .getCurrentlyBeingViewedFolderContent
            .length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          final individualItem =
              Provider.of<FolderAndNoteManagerProvider>(context)
                  .getCurrentlyBeingViewedFolderContent[index];
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
      ),
    );
  }
}
