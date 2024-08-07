import 'package:aspireme_flutter/CommonllyUsedComponents/CustomTopAppBar.dart';
import 'package:aspireme_flutter/CommonllyUsedComponents/FloatingBottomNav.dart';
import 'package:aspireme_flutter/Pages/FolderListPage.dart';
import 'package:aspireme_flutter/Pages/HomePage.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:aspireme_flutter/Providers/Theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(create: (context) => Pagecontrollerprovider())
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
      home: Scaffold(
          appBar: null,
          body: Stack(
            children: [
              PageView(
                controller:
                    context.read<Pagecontrollerprovider>().getPageController,
                onPageChanged: whenPageSwiped,
                children: const [Homepage(), Folderlistpage()],
              ),
              const Align(
                alignment: Alignment.topCenter,
                child: Customtopappbar(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FloatingBottomNav(),
              )
            ],
          )),
    );
  }

  void whenPageSwiped(int index) {
    setState(() {
      final pageControllerProvider = context.read<Pagecontrollerprovider>();

      pageControllerProvider.setPageIndex = index;
    });
  }
}
