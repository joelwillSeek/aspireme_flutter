import 'package:aspireme_flutter/Pages/Folder%20And%20Document%20View/Parts/DocumentWidget.dart';
import 'package:aspireme_flutter/Pages/Folder%20And%20Document%20View/Parts/FolderWidget.dart';
import 'package:aspireme_flutter/Providers/DirectoryStrucutreManagerProvider.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderAndDocumentListPage extends StatelessWidget {
  const FolderAndDocumentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.surface),
          child: FutureBuilder(
            future: Future.wait([
              Provider.of<DirectoryStructureManagerProvider>(context)
                  .getCurrentlySelectedSubFolders,
              Provider.of<DirectoryStructureManagerProvider>(context)
                  .getCurrentlySelectedSubDocuments
            ]),
            builder: documentAndFolderFutureBuilder,
          ),
        ));
  }

  Widget documentAndFolderFutureBuilder(
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
        'No Folders Or Documents Are Available',
        style: TextStyle(color: Colors.white),
      ));
    }

    final subFolders = snapShot.data![0];
    final subDocuments = snapShot.data![1];
    return GridViewOfFolderAndDocument(
      subDocuments: subDocuments,
      subFolders: subFolders,
    );
  }
}

class GridViewOfFolderAndDocument extends StatelessWidget {
  final List subFolders;
  final List subDocuments;
  const GridViewOfFolderAndDocument(
      {required this.subDocuments, required this.subFolders, super.key});

  Widget folderDocumentGrid() {
    final items = <Widget>[];

    items.addAll(subFolders
        .map((element) => GridTile(child: FolderWidget(folder: element))));
    items.addAll(subDocuments.map(
        (element) => GridTile(child: DocumentWidget(documentModel: element))));

    return GridView.count(
      crossAxisCount: 3,
      children: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (didPop) async {
          if (didPop) return;
          final closedTheFolder = await context
              .read<DirectoryStructureManagerProvider>()
              .closedFolder(context);

          if (!closedTheFolder && context.mounted) {
            context.read<Pagecontrollerprovider>().changePage(0, context);
          }
        },
        canPop: false,
        child: folderDocumentGrid());
  }
}
