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
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Customtopappbar(
          showSettingsButton: false,
        ),
      ),
      body: ListView(
        children: [
          const CustomCheckbox(),
          ListTile(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (context) => const LoadingWidget());
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
      ),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({super.key});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
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
    // TODO: implement dispose
    initalized = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: const Text("Dark Theme"),
        value: checker,
        onChanged: (didChecked) {
          setState(() {
            checker = didChecked ?? false;
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
