import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/BackEnd/SqlDatabase.dart';
import 'package:aspireme_flutter/Providers/FolderProvider.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Folderlistpage extends StatelessWidget {
  Folderlistpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.surface),
          child: FutureBuilder<List<Folder>>(
            future: Provider.of<Folderprovider>(context)
                .getAllFolders, // Ensure this is a Future
            builder:
                (BuildContext context, AsyncSnapshot<List<Folder>> snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapShot.hasError) {
                return Center(
                    child: Text(
                  'Error: ${snapShot.error}',
                  style: const TextStyle(color: Colors.red),
                ));
              } else if (!snapShot.hasData || snapShot.data!.isEmpty) {
                return const Center(
                    child: Text(
                  'No folders available',
                  style: TextStyle(color: Colors.white),
                ));
              } else {
                final folders = snapShot.data!;
                return GridView.builder(
                  itemCount: folders.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return individualFolder(
                      context,
                      folders[index].name,
                    );
                  },
                );
              }
            },
          )),
    );
  }

  Widget individualFolder(BuildContext context, String? name) {
    return Column(
      children: [
        IconButton(
            onPressed: () {
              context.read<Pagecontrollerprovider>().changePage(2, context);
            },
            iconSize: 10.0,
            icon: Image.asset("asset/Icons/folder_icon.png")),
        SizedBox(
            width: 100.0,
            height: 40.0,
            child: Text(
              name ?? "Empty",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              softWrap: false,
            )),
      ],
    );
  }
}
