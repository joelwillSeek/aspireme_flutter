import 'package:aspireme_flutter/Main%20Components/dialog_create_document_and_folder.dart';
import 'package:aspireme_flutter/Main%20Components/sync_button.dart';
import 'package:aspireme_flutter/Pages/Folder%20And%20Document%20View/folder_and_document_list_page.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/floating_bottom_nav.dart';
import 'package:aspireme_flutter/Pages/Home%20Page/HomePage.dart';
import 'package:aspireme_flutter/Pages/Settings/settings_page.dart';
import 'package:aspireme_flutter/Providers/Datastructure/directory_strucutre_provider.dart';
import 'package:aspireme_flutter/Providers/Tutorial/tutorial_provider.dart';
import 'package:aspireme_flutter/Providers/UI/PageControllerProvider.dart';
import 'package:aspireme_flutter/Providers/UI/theme_provider.dart';
import 'package:aspireme_flutter/Theme/Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
