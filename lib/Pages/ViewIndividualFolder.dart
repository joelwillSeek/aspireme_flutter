// import 'package:aspireme_flutter/BackEnd/Models/Note.dart';
// import 'package:aspireme_flutter/CommonllyUsedComponents/NotesWidget.dart';
// import 'package:aspireme_flutter/Providers/FolderAndNoteProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// /**
//  * Instead of having an add button on nav bar have a floating button
//  */

// class Viewindividualfolder extends StatelessWidget {
//   Viewindividualfolder({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Theme.of(context).colorScheme.surface,
//         child: FutureBuilder<List<Note>>(
//           future: Provider.of<FolderAndNoteProvider>(context)
//               .getNotesOfFolder(context), // Ensure this is a Future
//           builder: (BuildContext context, AsyncSnapshot<List<Note>> snapShot) {
//             if (snapShot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapShot.hasError) {
//               return Center(
//                   child: Text(
//                 'Error: ${snapShot.error}',
//                 style: const TextStyle(color: Colors.red),
//               ));
//             } else if (!snapShot.hasData || snapShot.data!.isEmpty) {
//               return const Center(
//                   child: Text(
//                 'No Notes available',
//                 style: TextStyle(color: Colors.white),
//               ));
//             } else {
//               final notes = snapShot.data!;
//               return GridView.builder(
//                 itemCount: notes.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 1,
//                 ),
//                 itemBuilder: (BuildContext context, int index) {
//                   return NotesWidget(note: notes[index]);
//                 },
//               );
//             }
//           },
//         ));
//   }
// }
