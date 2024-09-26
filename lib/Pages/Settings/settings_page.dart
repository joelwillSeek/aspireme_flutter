import 'package:aspireme_flutter/BackEnd/Database/SqlDatabase.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
import 'package:aspireme_flutter/Providers/BackEnd/FirebaseProvider.dart';
import 'package:aspireme_flutter/Providers/UI/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SwitchDarkMode(),
        deleteAllDataButton(context),
        const SignInButton()
      ],
    );
  }

  ListTile deleteAllDataButton(BuildContext context) {
    return ListTile(
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
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              signinClick(context);
            },
            child: Text(signedInOrNot(context))),
        const Icon(Icons.person)
      ],
    );
  }

  String signedInOrNot(BuildContext buildContext) =>
      buildContext.read<UserProfile>().getUser == null
          ? "Sign In"
          : "You are signed in.";

  Future<void> signinClick(BuildContext context) async {
    final firebaseProvider = context.read<UserProfile>();
    if (firebaseProvider.getUser != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Already Signed In")));
      return;
    }
    showDialog(context: context, builder: (context) => const LoadingWidget());
    await firebaseProvider.signIn();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}

class SwitchDarkMode extends StatefulWidget {
  const SwitchDarkMode({super.key});

  @override
  State<SwitchDarkMode> createState() => _SwitchDarkModeState();
}

class _SwitchDarkModeState extends State<SwitchDarkMode> {
  late bool checker = ThemeMode.system == ThemeMode.dark;
  bool initalized = false;

  BuildContext? buildContext;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initalized || buildContext == null) return;
    checker = buildContext!.read<ThemeProvider>().isDarkMode(buildContext!);
    initalized = true;
  }

  @override
  void dispose() {
    initalized = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Dark Theme"),
          Switch(
              activeColor: Theme.of(context).colorScheme.secondary,
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
              })
        ],
      ),
    );
  }
}
