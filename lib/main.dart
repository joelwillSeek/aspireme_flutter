import 'package:aspireme_flutter/Providers/BackEnd/FirebaseProvider.dart';
import 'package:aspireme_flutter/Providers/Tutorial/tutorial_provider.dart';
import 'package:aspireme_flutter/Providers/UI/DocumentEditingPageProvider.dart';
import 'package:aspireme_flutter/Providers/UI/FlashCardProvider.dart';
import 'package:aspireme_flutter/Providers/Datastructure/directory_strucutre_provider.dart';
import 'package:aspireme_flutter/Providers/UI/PageControllerProvider.dart';
import 'package:aspireme_flutter/Providers/UI/theme_provider.dart';
import 'package:aspireme_flutter/Main%20Components/main_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
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
