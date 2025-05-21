import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
import 'package:aspireme_flutter/Providers/Datastructure/directory_strucutre_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogCreateDocumentAndFolder extends StatelessWidget {
  const DialogCreateDocumentAndFolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
          height: 230,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: DefaultTabController(
                length: 2,
                child: Column(children: [
                  tabBar(context),
                  Expanded(
                      child: TabBarView(children: [
                    createFolderTab(context),
                    createDocumentTab(context)
                  ]))
                ])),
          )),
    );
  }

  TabBar tabBar(BuildContext context) {
    return TabBar(
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      dividerColor: Theme.of(context).colorScheme.onSecondary,
      indicatorColor: Theme.of(context).colorScheme.secondary,
      labelColor: Theme.of(context).colorScheme.onSecondary,
      unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
      tabs: const [
        Tab(
          text: "Folder",
          icon: Icon(Icons.folder),
        ),
        Tab(text: "Document", icon: Icon(Icons.edit_document))
      ],
    );
  }

  Future<void> doneClicked(
      BuildContext context, TextEditingController textEditingController) async {
    if (textEditingController.text.isNotEmpty) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const LoadingWidget());

      await context
          .read<DirectoryStructureManagerProvider>()
          .addDocument(textEditingController.text);

      if (context.mounted) {
        Navigator.pop(context);

        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Make sure you enter at least one letter")));
    }
  }

  Future<void> yesClicked(
      BuildContext context, TextEditingController folderNameInputText) async {
    if (folderNameInputText.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Please Enter A Name For Your Folder",
        style: TextStyle(color: Colors.white),
      )));
    } else {
      final folderAndNoteProvider =
          context.read<DirectoryStructureManagerProvider>();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const LoadingWidget());
      await folderAndNoteProvider.addFolder(folderNameInputText.text);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Widget createDocumentTab(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    return Column(
      children: [
        documentNameTextEditor(textEditingController, context),
        doneOrCancelButton(context, textEditingController)
      ],
    );
  }

  Row doneOrCancelButton(
      BuildContext context, TextEditingController textEditingController) {
    return Row(
      children: [
        Expanded(
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.tertiary)),
                onPressed: () {
                  doneClicked(context, textEditingController);
                },
                child: Text(
                  "Done",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ))),
        Expanded(
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.error)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.onError),
                    "Cancel"))),
      ],
    );
  }

  Expanded documentNameTextEditor(
      TextEditingController textEditingController, BuildContext context) {
    return Expanded(
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSecondary)),
            border: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSecondary)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onSecondary)),
            hintText: "Chemistry...",
            hintStyle:
                TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
      ),
    );
  }

  Widget createFolderTab(BuildContext context) {
    TextEditingController folderNameInputText = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Column(
            children: [
              labelForFolderName(folderNameInputText, context),
              doneOrCaneclButtons(context, folderNameInputText)
            ],
          )
        ],
      ),
    );
  }

  Row doneOrCaneclButtons(
      BuildContext context, TextEditingController folderNameInputText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: TextButton(
                onPressed: () {
                  yesClicked(context, folderNameInputText);
                },
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.tertiary)),
                child: Text(
                  "Done",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ))),
        Expanded(
            child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Theme.of(context).colorScheme.error)),
          child: Text(
            "Cancel",
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
        ))
      ],
    );
  }

  TextField labelForFolderName(
      TextEditingController folderNameInputText, BuildContext context) {
    return TextField(
      controller: folderNameInputText,
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.onSecondary)),
          border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.onSecondary)),
          enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.onSecondary)),
          hintText: "Folder Name",
          hintStyle:
              TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
    );
  }
}
