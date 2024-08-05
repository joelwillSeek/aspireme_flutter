import 'package:aspireme_flutter/CommonllyUsed/FloatingBottomNav.dart';
import 'package:aspireme_flutter/Providers/Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pulsator/pulsator.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
      decoration:
          BoxDecoration(color: context.read<ThemeProvider>().getPrimaryColor),
      child: Column(
        children: [
          customHomeAppbar(context),
          flashcardButton(context),
          FloatingBottomNav()
        ],
      ),
    ));
  }

  Widget customHomeAppbar(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: IconButton(
                onPressed: null,
                icon: Image.asset(
                  "asset/button/back.png",
                  scale: context.read<ThemeProvider>().getIconScale,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "Home",
                textAlign: TextAlign.center,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: context.read<ThemeProvider>().getHeadingFontSize,
                    color: context.read<ThemeProvider>().getAccentColor),
              ),
            ),
            Expanded(
                child: IconButton(
              onPressed: null,
              icon: Image.asset(
                "asset/button/settings.png",
                scale: context.read<ThemeProvider>().getIconScale,
              ),
            ))
          ],
        ));
  }

  flashcardButton(BuildContext context) {
    return Expanded(
        child: Center(
            child: Pulsator(
      style: PulseStyle(color: context.read<ThemeProvider>().getAccentColor),
      count: 2,
      duration: const Duration(seconds: 4),
      repeat: 0,
      startFromScratch: true,
      autoStart: true,
      fit: PulseFit.contain,
      child: Image.asset("asset/button/task_hover.png"),
    )));
  }
}
