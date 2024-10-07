import 'dart:io';

import 'package:aspireme_flutter/BackEnd/Database/sql_database.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
import 'package:aspireme_flutter/Providers/BackEnd/FirebaseProvider.dart';
import 'package:aspireme_flutter/Providers/Tutorial/tutorial_provider.dart';
import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class SyncButton extends StatelessWidget {
  const SyncButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => IconButton(
            key: context.read<TutorialProvider>().syncNavButton,
            onPressed: () {
              syncClicked(context);
            },
            icon: const Icon(Icons.loop)));
  }

  Future<void> _pickDirectory(BuildContext context) async {
    Directory directory = Directory(FolderPicker.rootPath);

    Directory? newDirectory = await FolderPicker.pick(
        allowFolderCreation: true,
        context: context,
        rootDirectory: directory,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))));

    try {
      if (context.mounted) {
        showDialog(
            context: context, builder: (context) => const LoadingWidget());
      }

      String dbPath = join(await getDatabasesPath(), Sqldatabse.databaseName);

      if (newDirectory == null) throw ("New Directory in Main.dart is null");

      String externalDbPath = join(newDirectory.path, "mydatabase.db");

      File dbFile = File(dbPath);

      await dbFile.copy(externalDbPath);

      debugPrint('Database exported to: $externalDbPath');
    } catch (e) {
      debugPrint("_pick diectory : $e");
    } finally {
      if (context.mounted) Navigator.pop(context);
    }
  }

  Future<void> syncClicked(BuildContext context) async {
    final firebaseProvider = context.read<UserProfile>();

    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text(
                "Choose Sync Options",
                textAlign: TextAlign.center,
              ),
              children: [
                // TextButton.icon(
                //     onPressed: () async {
                //       await firebaseProvider.firebaseSync(context);
                //       // await firebaseSync();
                //     },
                //     icon: SvgPicture.asset("asset/Icons/firebase.svg"),
                //     label: Text(
                //       "Firebase",
                //       style: TextStyle(
                //           color: Theme.of(context).colorScheme.secondary),
                //     )),
                TextButton.icon(
                    onPressed: () async {
                      await exportAsDbClicked(context);
                    },
                    icon: Image.asset("asset/Icons/icons8-sql-64.png"),
                    label: Text(
                      "Export as .db format",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ))
              ],
            ));
  }

  Future<void> exportAsDbClicked(BuildContext context) async {
    if (await Permission.storage.request().isGranted) {
      if (context.mounted) {
        await _pickDirectory(context);
      }
    } else {
      if (context.mounted) {
        requestPermission(context);
      }
    }
  }

  Future<void> requestPermission(BuildContext context) async {
    // Request permission
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted && context.mounted) {
      await _pickDirectory(context);
    } else if ((status.isDenied || status.isPermanentlyDenied) &&
        context.mounted) {
      // Handle denied permissions
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please allow storage permission to proceed'),
      ));

      // Optionally open app settings if permanently denied
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  // Future<void> firebaseSync() async {
  //   // Implement your Firebase sync logic here
  //    if (await Permission.) {
  //     if (context.mounted) {
  //       await _pickDirectory(context);
  //     }
  //   } else {
  //     if (context.mounted) {
  //       requestPermission(context);
  //     }
  //   }
  // }
}
