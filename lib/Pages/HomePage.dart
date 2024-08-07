import 'package:aspireme_flutter/CommonllyUsedComponents/CustomTopAppBar.dart';
import 'package:flutter/material.dart';
import 'package:aspireme_flutter/Providers/Theme.dart';
import 'package:provider/provider.dart';
import 'package:pulsator/pulsator.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: context.read<ThemeProvider>().getPrimaryColor),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: context.read<ThemeProvider>().getAccentColor,
              height: 3.0,
              margin: EdgeInsets.only(top: 140.0),
            ),
          ),
          flashcardButton(context),
        ],
      ),
    );
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
