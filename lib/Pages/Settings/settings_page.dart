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
      children: const [
        SwitchDarkMode(),
        SignInButton(),
        DeleteAllDataButton(),
        DeleteAccountData()
      ],
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: GestureDetector(
          onTap: () {
            signinClick(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                "asset/Icons/google.svg",
                width: 40.0,
                height: 40.0,
              ),
              Text(
                signedInOrNot(context),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 15),
              ),
            ],
          ),
        ));
  }

  String signedInOrNot(BuildContext buildContext) =>
      buildContext.read<UserProfile>().getUser == null
          ? "Not signed In"
          : "You are already signed";

  Future<void> signinClick(BuildContext context) async {
    final firebaseProvider = context.read<UserProfile>();

    showDialog(context: context, builder: (context) => const LoadingWidget());
    await firebaseProvider.signIn(context);
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

class DeleteAllDataButton extends StatelessWidget {
  const DeleteAllDataButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListTile(
          onTap: () async {
            dialogForDeleteAllDataButton(context);
          },
          title: const Text(
            "Delete All Data",
            style: TextStyle(color: Colors.red),
          ),
        ));
  }

  Future<void> deleteDatabaseData(BuildContext context) async {
    if (context.mounted) {
      try {
        showDialog(
            context: context, builder: (context) => const LoadingWidget());
        await Sqldatabse.resetDatabase(context);
        // ignore: use_build_context_synchronously
        await context.read<UserProfile>().firebaseSync(context);
      } catch (e) {
        debugPrint("DeleteDatabaseData : $e");
      } finally {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }

  void dialogForDeleteAllDataButton(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text(
                "Are You Sure?",
                textAlign: TextAlign.center,
              ),
              children: [
                Column(
                  children: [
                    const Text(
                        "This will delete all your data. P.S Sign In Again required"),
                    const SizedBox(height: 10.0),
                    const Text(
                      "This action cannot be undone.",
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10.0),
                    deleteButton(context),
                  ],
                )
              ],
            ));
  }

  ElevatedButton deleteButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary)),
      onPressed: () async {
        try {
          await deleteDatabaseData(context);
        } catch (e) {
          debugPrint("deleteButton For Data : $e");
        } finally {
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Text(
        "Delete",
        style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
      ),
    );
  }
}

class DeleteAccountData extends StatelessWidget {
  const DeleteAccountData({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListTile(
          onTap: () async {
            dialogFordeleteMyAccount(context);
          },
          title: const Text(
            "Delete Account Data",
            style: TextStyle(color: Colors.red),
          ),
        ));
  }

  void dialogFordeleteMyAccount(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text(
                "Are You Sure?",
                textAlign: TextAlign.center,
              ),
              children: [
                Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                            "This will delete all your user data and login data.")),
                    const SizedBox(height: 10.0),
                    const Text(
                      "This action cannot be undone.",
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10.0),
                    deleteButton(context),
                  ],
                )
              ],
            ));
  }

  ElevatedButton deleteButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary)),
      onPressed: () async {
        await deleteButtonClicked(context);
      },
      child: Text("Delete",
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
    );
  }

  Future<void> deleteButtonClicked(BuildContext context) async {
    try {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        await deleteDatabaseData(context);
        // ignore: use_build_context_synchronously
        await context.read<UserProfile>().firebaseSync(context);

        await context.read<UserProfile>().deleteAccount(context);
      }
    } catch (e) {
      debugPrint("deleteButtonClicked : $e");
    } finally {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> deleteDatabaseData(BuildContext context) async {
    try {
      showDialog(context: context, builder: (context) => const LoadingWidget());
      await Sqldatabse.resetDatabase(context);
    } catch (e) {
      debugPrint("deleteDatabaseData : $e");
    } finally {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
