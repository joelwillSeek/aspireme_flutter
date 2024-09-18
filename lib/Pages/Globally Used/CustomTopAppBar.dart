import 'package:aspireme_flutter/BackEnd/Database/SqlDatabase.dart';
import 'package:aspireme_flutter/Pages/Settings/settings_page.dart';
import 'package:aspireme_flutter/Providers/DirectoryStrucutreManagerProvider.dart';
import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:aspireme_flutter/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                      onPressed: () async {
                        if (!(widget.showSettingsButton)) {
                          Navigator.pop(context);
                          return;
                        }

                        if (context
                                .read<Pagecontrollerprovider>()
                                .getPageIndex ==
                            1) {
                          final closedTheFolder = await context
                              .read<DirectoryStructureManagerProvider>()
                              .closedFolder(context);

                          if (!closedTheFolder && context.mounted) {
                            context
                                .read<Pagecontrollerprovider>()
                                .changePage(0, context);
                          }

                          return;
                        }

                        if (context
                                .read<Pagecontrollerprovider>()
                                .getPageIndex ==
                            0) {
                          showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Exit App?'),
                              content:
                                  const Text('Do you want to exit the app?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => SystemNavigator.pop(),
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
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
                        fontSize: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.fontSize,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
                const Expanded(
                  child: Placeholder(
                    fallbackHeight: 2,
                    fallbackWidth: 10,
                    color: Colors.transparent,
                  ),
                )
              ],
            )),
      ],
    );
  }

  String whatToDisplayText() {
    if (widget.documentEditingPage == true) return "Document";

    if (widget.showSettingsButton == false) {
      return "Setting";
    }

    return Provider.of<Pagecontrollerprovider>(context).getCurrentPageName;
  }
}
