import 'package:aspireme_flutter/Pages/Settings/settings_page.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:aspireme_flutter/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customtopappbar extends StatefulWidget {
  final bool showSettingsButton;
  const Customtopappbar({this.showSettingsButton = true, super.key});

  @override
  State<Customtopappbar> createState() => _CustomtopappbarState();
}

class _CustomtopappbarState extends State<Customtopappbar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
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
                    widget.showSettingsButton
                        ? Provider.of<Pagecontrollerprovider>(context)
                            .getCurrentPageName
                        : "Setting",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontSize:
                            context.read<ThemeProvider>().getHeadingFontSize,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Expanded(
                    child: widget.showSettingsButton
                        ? IconButton(
                            onPressed: () async {
                              // print("Folder table");
                              // await Sqldatabse.getFoldersWithCustomQuery();
                              // print("Note table");
                              // await Sqldatabse.getNotesWithCustomQuery();
                              // debugPrint("Document table");
                              // await Sqldatabse.getDocumentsWithCustomQuery();
                              //await Sqldatabase.resetDatabase();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SettingsPage()));
                            },
                            icon: Image.asset(
                              "asset/button/settings.png",
                              scale: context.read<ThemeProvider>().getIconScale,
                            ),
                          )
                        : const Placeholder(
                            fallbackHeight: 90,
                            color: Colors.transparent,
                          ))
              ],
            )),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            height: 3.0,
          ),
        ),
      ],
    );
  }
}
