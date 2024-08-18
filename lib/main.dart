import 'package:aspireme_flutter/BackEnd/SqlDatabase.dart';
import 'package:aspireme_flutter/CommonllyUsedComponents/CustomTopAppBar.dart';
import 'package:aspireme_flutter/CommonllyUsedComponents/FloatingBottomNav.dart';
import 'package:aspireme_flutter/Pages/FolderAndNoteListPage.dart';
import 'package:aspireme_flutter/Pages/HomePage.dart';
import 'package:aspireme_flutter/Pages/NotesEditingPage.dart';
import 'package:aspireme_flutter/Pages/ViewIndividualFolder.dart';
import 'package:aspireme_flutter/Providers/FolderAndNoteProvider.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:aspireme_flutter/Providers/Theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => Pagecontrollerprovider()),
        ChangeNotifierProvider(create: (context) => FolderAndNoteProvider()),
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

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme(
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
                onSurface: Theme.of(context).colorScheme.primary)),
        home: Scaffold(
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(120), child: Customtopappbar()),
          body: PageView(
            controller:
                context.read<Pagecontrollerprovider>().getPageController,
            onPageChanged: whenPageSwiped,
            children: [
              const Homepage(),
              FolderAndNoteListPage(),
              // Viewindividualfolder(),
            ],
          ),
          bottomNavigationBar: const FloatingBottomNav(),
        ));
  }

  void whenPageSwiped(int index) {
    setState(() {
      final pageControllerProvider = context.read<Pagecontrollerprovider>();

      pageControllerProvider.setPageIndex = index;
    });
  }
}
