import 'package:aspireme_flutter/BackEnd/Database/SqlDatabase.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/CustomTopAppBar.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
import 'package:aspireme_flutter/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Dark Theme"), SwitchDarkMode()],
          ),
        ),
        ListTile(
          onTap: () async {
            showDialog(
                context: context, builder: (context) => const LoadingWidget());
            await Sqldatabse.resetDatabase(context);

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          title: const Text(
            "Delete All Data",
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }
}

class SwitchDarkMode extends StatefulWidget {
  const SwitchDarkMode({super.key});

  @override
  State<SwitchDarkMode> createState() => _SwitchDarkModeState();
}

class _SwitchDarkModeState extends State<SwitchDarkMode> {
  late bool checker;
  bool initalized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initalized) return;
    checker = context.read<ThemeProvider>().isDarkMode(context);
    initalized = true;
  }

  @override
  void dispose() {
    initalized = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
        activeColor: Theme.of(context).colorScheme.secondary,
        thumbColor:
            WidgetStatePropertyAll(Theme.of(context).colorScheme.onSecondary),
        value: checker,
        onChanged: (didChecked) {
          setState(() {
            checker = didChecked;
          });

          final themeProvider =
              Provider.of<ThemeProvider>(context, listen: false);
          if (checker) {
            themeProvider.setThemeMode(ThemeMode.dark);
          } else {
            themeProvider.setThemeMode(ThemeMode.light);
          }
        });
  }
}
