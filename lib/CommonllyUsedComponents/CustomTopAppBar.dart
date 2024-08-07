import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:aspireme_flutter/Providers/Theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customtopappbar extends StatefulWidget {
  const Customtopappbar({super.key});

  @override
  State<Customtopappbar> createState() => _CustomtopappbarState();
}

class _CustomtopappbarState extends State<Customtopappbar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 50.0),
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
                Provider.of<Pagecontrollerprovider>(context).getCurrentPageName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
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
}
