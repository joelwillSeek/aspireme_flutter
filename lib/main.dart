import 'dart:io';
import 'package:aspireme_flutter/BackEnd/Database/sql_database.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/floating_bottom_nav.dart';
import 'package:aspireme_flutter/Pages/Folder%20And%20Document%20View/folder_and_document_list_page.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
import 'package:aspireme_flutter/Pages/Home%20Page/HomePage.dart';
import 'package:aspireme_flutter/Pages/Settings/settings_page.dart';
import 'package:aspireme_flutter/Providers/BackEnd/FirebaseProvider.dart';
import 'package:aspireme_flutter/Providers/Tutorial/tutorial_provider.dart';
import 'package:aspireme_flutter/Theme/Theme.dart';
import 'package:aspireme_flutter/Providers/UI/DocumentEditingPageProvider.dart';
import 'package:aspireme_flutter/Providers/UI/FlashCardProvider.dart';
import 'package:aspireme_flutter/Providers/Datastructure/directory_strucutre_provider.dart';
import 'package:aspireme_flutter/Providers/UI/PageControllerProvider.dart';
import 'package:aspireme_flutter/Providers/UI/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => FlashCardProvider()),
        ChangeNotifierProvider(create: (context) => Pagecontrollerprovider()),
        ChangeNotifierProvider(create: (context) => TutorialProvider()),
        ChangeNotifierProvider(create: (context) => UserProfile()),
        ChangeNotifierProvider(
            create: (context) => DocumentEditingPageProvider()),
        ChangeNotifierProvider(
            create: (context) => DirectoryStructureManagerProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  late BuildContext buildContextMy;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (!(buildContextMy.mounted)) return;

    Provider.of<DirectoryStructureManagerProvider>(buildContextMy,
            listen: false)
        .resetStructure();

    buildContextMy.read<ThemeProvider>().setThemeMode(
        MediaQuery.of(buildContextMy).platformBrightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    buildContextMy = context;
    return MaterialApp(
      theme: themeLight,
      darkTheme: themeDark,
      themeMode: Provider.of<ThemeProvider>(context).currentTheme,
      home: Scaffold(
        appBar: appBarWidget(context),
        // appBar: const PreferredSize(
        //     preferredSize: Size.fromHeight(120), child: Customtopappbar()),
        body: pageViewWidget(context),
        floatingActionButton: showFAB(context),
        bottomNavigationBar: const FloatingBottomNav(),
      ),
    );
  }

  Builder? showFAB(BuildContext context) {
    return Provider.of<Pagecontrollerprovider>(context).getPageIndex == 1
        ? Builder(builder: (context) {
            return setFloatingButton(context);
          })
        : null;
  }

  PageView pageViewWidget(BuildContext context) {
    return PageView(
      controller: context.read<Pagecontrollerprovider>().getPageController,
      onPageChanged: (index) {
        whenPageSwiped(index, context);
      },
      children: const [Homepage(), FolderAndDocumentListPage(), SettingsPage()],
    );
  }

  Future<void> backButtonAppBarClick(BuildContext context) async {
    final pageProvider = context.read<Pagecontrollerprovider>();

    if (pageProvider.getPageIndex != 0 &&
        pageProvider.getPageIndex != 1 &&
        context.mounted) {
      pageProvider.goBackPage(pageProvider.getPageIndex - 1, context);
    }

    if (pageProvider.getPageIndex == 1) {
      final closedTheFolder = await context
          .read<DirectoryStructureManagerProvider>()
          .closedFolder(context);

      if (!closedTheFolder && context.mounted) {
        pageProvider.goBackPage(pageProvider.getPageIndex - 1, context);
      }

      return;
    }

    if (pageProvider.getPageIndex == 0) {
      dialogExitingApp(context);
    }
  }

  AppBar appBarWidget(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
          key: context.read<TutorialProvider>().backNavButton,
          onPressed: () {
            backButtonAppBarClick(context);
          },
          icon: const Icon(Icons.arrow_back_ios)),
      title:
          Text(Provider.of<Pagecontrollerprovider>(context).getCurrentPageName),
      actions: const [SyncButton()],
    );
  }

  void dialogExitingApp(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App?'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text(
              'Yes',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton setFloatingButton(BuildContext context) {
    return FloatingActionButton(
      key: context.read<TutorialProvider>().addFloadingActionButton,
      elevation: 20,
      focusColor: Colors.transparent,
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                const DialogCreateDocumentAndFolder());
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  void whenPageSwiped(int index, BuildContext context) {
    setState(() {
      final pageControllerProvider = context.read<Pagecontrollerprovider>();

      pageControllerProvider.setPageIndex = index;
    });
  }
}

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
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
      dividerColor: Theme.of(context).colorScheme.secondary,
      indicatorColor: Theme.of(context).colorScheme.secondary,
      labelColor: Theme.of(context).colorScheme.secondary,
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
    if (textEditingController.text.length > 1) {
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
                child: const Text(
                  "Done",
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
            border: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.secondary)),
            enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.secondary)),
            hintText: "Chemistry...",
            hintStyle:
                TextStyle(color: Theme.of(context).colorScheme.secondary)),
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
                child: const Text(
                  "Done",
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
                  BorderSide(color: Theme.of(context).colorScheme.secondary)),
          enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.secondary)),
          hintText: "Folder Name",
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary)),
    );
  }
}

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
                TextButton.icon(
                    onPressed: () async {
                      await firebaseProvider.syncDatabase(context);
                    },
                    icon: SvgPicture.asset("asset/Icons/firebase.svg"),
                    label: Text(
                      "Firebase",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    )),
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
    if (status.isGranted) {
      await _pickDirectory(context);
    } else if (status.isDenied || status.isPermanentlyDenied) {
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
}
