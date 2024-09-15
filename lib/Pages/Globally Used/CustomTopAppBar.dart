import 'package:aspireme_flutter/BackEnd/Database/SqlDatabase.dart';
import 'package:aspireme_flutter/Pages/Settings/settings_page.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:aspireme_flutter/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customtopappbar extends StatefulWidget {
  final bool showSettingsButton;
  final bool documentEditingPage;
  const Customtopappbar(
      {this.showSettingsButton = true,
      this.documentEditingPage = false,
      super.key});

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
                        Provider.of<ThemeProvider>(context).isDarkMode(context)
                            ? "asset/button/back.png"
                            : "asset/button/back_black.png",
                        scale: Provider.of<ThemeProvider>(context)
                                .isDarkMode(context)
                            ? context.read<ThemeProvider>().getIconScale
                            : context.read<ThemeProvider>().getIconScale - 0.7,
                      )),
                ),
                Expanded(
                  child: Text(
                    whatToDisplayText(),
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
                              print("Folder table");
                              await Sqldatabse.getFoldersWithCustomQuery();
                              print("Note table");
                              await Sqldatabse.getNotesWithCustomQuery();
                              debugPrint("Document table");
                              await Sqldatabse.getDocumentsWithCustomQuery();
                              //await Sqldatabse.resetDatabase();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SettingsPage()));
                            },
                            icon: Image.asset(
                              Provider.of<ThemeProvider>(context)
                                      .isDarkMode(context)
                                  ? "asset/button/settings.png"
                                  : "asset/button/settings_black.png",
                              scale: Provider.of<ThemeProvider>(context)
                                      .isDarkMode(context)
                                  ? context.read<ThemeProvider>().getIconScale
                                  : context.read<ThemeProvider>().getIconScale -
                                      0.7,
                            ))
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

  String whatToDisplayText() {
    if (widget.documentEditingPage == true) return "Document";

    if (widget.showSettingsButton) {
      return "Setting";
    }
    return Provider.of<Pagecontrollerprovider>(context).getCurrentPageName;
  }
}
