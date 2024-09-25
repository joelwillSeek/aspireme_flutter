import 'package:aspireme_flutter/BackEnd/Models/Folder.dart';
import 'package:aspireme_flutter/Pages/Folder%20And%20Document%20View/Parts/DocumentWidget.dart';
import 'package:aspireme_flutter/Pages/Folder%20And%20Document%20View/Parts/FolderWidget.dart';
import 'package:aspireme_flutter/Providers/Datastructure/DirectoryStrucutreManagerProvider.dart';
import 'package:aspireme_flutter/Providers/UI/PageControllerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderAndDocumentListPage extends StatefulWidget {
  const FolderAndDocumentListPage({super.key});

  @override
  State<FolderAndDocumentListPage> createState() =>
      _FolderAndDocumentListPageState();
}

class _FolderAndDocumentListPageState extends State<FolderAndDocumentListPage> {
  String? currentDropDownValue = "alpha";

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (didPop) async {
          if (didPop) return;
          final closedTheFolder = await context
              .read<DirectoryStructureManagerProvider>()
              .closedFolder(context);

          if (!closedTheFolder && context.mounted) {
            context.read<Pagecontrollerprovider>().goNextPage(0, context);
          }
        },
        canPop: false,
        child: ListView(scrollDirection: Axis.vertical, children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Order Mode"),
                    DropdownButton(
                        value: currentDropDownValue,
                        items: const [
                          DropdownMenuItem(
                            value: "alpha",
                            child: Text("a...z"),
                          ),
                          DropdownMenuItem(
                            value: "type",
                            child: Text("Type"),
                          )
                        ],
                        onChanged: (newValue) {
                          setState(() {
                            currentDropDownValue = newValue;
                          });
                        })
                  ],
                ),
              )),
          Align(
              child: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.surface),
            child: FutureBuilder<List<dynamic>?>(
              future: whichToGet(),
              builder: documentAndFolderFutureBuilder,
            ),
          ))
        ]));
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
      return Center(
          child: Text(
        'No Folders Or Documents Are Available',
        style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      ));
    }

    final mixedTypes = snapShot.data;
    // final subDocuments = snapShot.data![1];
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: GridViewOfFolderAndDocument(
        mixedTypes: mixedTypes ?? [],
      ),
    );
  }

  Future<List?> whichToGet() async {
    if (currentDropDownValue == "alpha") {
      return Provider.of<DirectoryStructureManagerProvider>(context)
          .getBothFoldersAndDocumentsByAlphabetial;
    } else if (currentDropDownValue == "type") {
      return Provider.of<DirectoryStructureManagerProvider>(context)
          .getBothFoldersAndDocumentsByType;
    }
    return null;
  }
}

class GridViewOfFolderAndDocument extends StatelessWidget {
  final List mixedTypes;

  const GridViewOfFolderAndDocument({required this.mixedTypes, super.key});

  Widget folderDocumentGrid() {
    final items = <Widget>[];

    items.addAll(mixedTypes.map(setGridTileToItems));

    return GridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      children: items,
    );
  }

  Widget setGridTileToItems(element) => element is Folder
      ? GridTile(child: FolderWidget(folder: element))
      : GridTile(child: DocumentWidget(documentModel: element));

  @override
  Widget build(BuildContext context) {
    return folderDocumentGrid();
  }
}
