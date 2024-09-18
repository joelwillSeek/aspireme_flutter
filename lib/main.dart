import 'package:aspireme_flutter/Pages/Globally%20Used/FloatingBottomNav.dart';
import 'package:aspireme_flutter/Pages/Folder%20And%20Document%20View/FolderAndDocumentListPage.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
import 'package:aspireme_flutter/Pages/Home%20Page/HomePage.dart';
import 'package:aspireme_flutter/Pages/Settings/settings_page.dart';
import 'package:aspireme_flutter/Theme/Theme.dart';
import 'package:aspireme_flutter/Providers/DocumentEditingPageProvider.dart';
import 'package:aspireme_flutter/Providers/FlashCardProvider.dart';
import 'package:aspireme_flutter/Providers/DirectoryStrucutreManagerProvider.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:aspireme_flutter/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => FlashCardProvider()),
        ChangeNotifierProvider(create: (context) => Pagecontrollerprovider()),
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

    Provider.of<DirectoryStructureManagerProvider>(context, listen: false)
        .resetStructure();

    context.read<ThemeProvider>().setThemeMode(
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeLight,
      darkTheme: themeDark,
      themeMode: Provider.of<ThemeProvider>(context).currentTheme,
      home: Scaffold(
        appBar: appBarWidget(),
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
      onPageChanged: whenPageSwiped,
      children: const [Homepage(), FolderAndDocumentListPage(), SettingsPage()],
    );
  }

  Future<void> backButtonAppBarClick() async {
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

  AppBar appBarWidget() {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
          onPressed: backButtonAppBarClick,
          icon: const Icon(Icons.arrow_back_ios)),
      title:
          Text(Provider.of<Pagecontrollerprovider>(context).getCurrentPageName),
      actions: [
        Builder(
            builder: (context) => IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Sync Comming soon"),
                    duration: Durations.medium4,
                  ));
                },
                icon: const Icon(Icons.loop)))
      ],
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
      elevation: 20,
      focusColor: Colors.transparent,
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                createFolderOrDocumentDialog(context));
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }

  Widget createFolderOrDocumentDialog(BuildContext context) {
    return Dialog(
      child: SizedBox(
          height: 230,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: DefaultTabController(
                length: 2,
                child: Column(children: [
                  TabBar(
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                    dividerColor: Theme.of(context).colorScheme.secondary,
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    labelColor: Theme.of(context).colorScheme.secondary,
                    unselectedLabelColor:
                        Theme.of(context).colorScheme.onPrimary,
                    tabs: const [
                      Tab(
                        text: "Folder",
                        icon: Icon(Icons.folder),
                      ),
                      Tab(text: "Document", icon: Icon(Icons.edit_document))
                    ],
                  ),
                  Expanded(
                      child: TabBarView(children: [
                    createFolderTab(context),
                    createDocumentTab(context)
                  ]))
                ])),
          )),
    );
  }

  Widget createDocumentTab(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    Future<void> doneClicked() async {
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

    return Column(
      children: [
        Expanded(
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary)),
                hintText: "Chemistry...",
                hintStyle:
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
        ),
        Row(
          children: [
            Expanded(
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.tertiary)),
                    onPressed: doneClicked,
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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onError),
                        "Cancel"))),
          ],
        )
      ],
    );
  }

  Widget createFolderTab(BuildContext context) {
    TextEditingController folderNameInputText = TextEditingController();

    Future<void> yesClicked() async {
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

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Column(
            children: [
              TextField(
                controller: folderNameInputText,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary)),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary)),
                    hintText: "Folder Name",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: TextButton(
                          onPressed: yesClicked,
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
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.error)),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onError),
                    ),
                  ))
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  void whenPageSwiped(int index) {
    setState(() {
      final pageControllerProvider = context.read<Pagecontrollerprovider>();

      pageControllerProvider.setPageIndex = index;
    });
  }
}
