import 'package:aspireme_flutter/Pages/Globally%20Used/CustomTopAppBar.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/FloatingBottomNav.dart';
import 'package:aspireme_flutter/Pages/Folder%20And%20Document%20View/FolderAndDocumentListPage.dart';
import 'package:aspireme_flutter/Pages/Home%20Page/HomePage.dart';
import 'package:aspireme_flutter/Providers/DocumentEditingPageProvider.dart';
import 'package:aspireme_flutter/Providers/FlashCardProvider.dart';
import 'package:aspireme_flutter/Providers/DirectoryStrucutreManagerProvider.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:aspireme_flutter/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
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
  ColorScheme darkColorScheme() {
    return ColorScheme(
        tertiary: Colors.green,
        onTertiary: Colors.white,
        brightness: Brightness.light,
        primary: const Color.fromARGB(255, 255, 240, 124),
        onPrimary: Colors.white,
        secondary: const Color.fromARGB(255, 93, 115, 126),
        onSecondary: Colors.white,
        error: const Color.fromARGB(255, 251, 110, 110),
        onError: Colors.white,
        surface: const Color.fromARGB(255, 30, 29, 29),
        onSurface: Theme.of(context).colorScheme.primary);
  }

  ColorScheme colorScheme() {
    return ColorScheme(
        tertiary: Colors.green,
        onTertiary: Colors.white,
        brightness: Brightness.light,
        primary: const Color.fromARGB(255, 255, 240, 124),
        onPrimary: Colors.white,
        secondary: const Color.fromARGB(255, 93, 115, 126),
        onSecondary: const Color.fromARGB(255, 0, 0, 0),
        error: const Color.fromARGB(255, 251, 110, 110),
        onError: Colors.white,
        surface: const Color.fromARGB(255, 255, 255, 255),
        onSurface: Theme.of(context).colorScheme.primary);
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: colorScheme()),
      darkTheme: ThemeData(colorScheme: darkColorScheme()),
      themeMode: Provider.of<ThemeProvider>(context).currentTheme,
      home: Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(120), child: Customtopappbar()),
        body: PageView(
          controller: context.read<Pagecontrollerprovider>().getPageController,
          onPageChanged: whenPageSwiped,
          children: const [
            Homepage(),
            FolderAndDocumentListPage(),
          ],
        ),
        bottomNavigationBar: const FloatingBottomNav(),
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
