import 'package:aspireme_flutter/BackEnd/Database/sql_database.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
import 'package:aspireme_flutter/Providers/BackEnd/FirebaseProvider.dart';
import 'package:aspireme_flutter/Providers/UI/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SwitchDarkMode(),
        const SignInButton(),
        deleteAllDataButton(context),
      ],
    );
  }

  Widget deleteAllDataButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListTile(
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
        ));
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  signinClick(context);
                },
                child: Text(
                  signedInOrNot(context),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 15),
                )),
            SvgPicture.asset(
              "asset/Icons/google.svg",
              width: 40.0,
              height: 40.0,
            )
          ],
        ));
  }

  String signedInOrNot(BuildContext buildContext) =>
      buildContext.read<UserProfile>().getUser == null
          ? "Not signed In"
          : "You are already signed";

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
          const Text(
            "Dark Theme",
            style: TextStyle(fontSize: 20),
          ),
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
