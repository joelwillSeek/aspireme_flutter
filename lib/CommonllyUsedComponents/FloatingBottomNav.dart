import 'package:aspireme_flutter/Providers/PageControllerProvider.dart';
import 'package:aspireme_flutter/Providers/Theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FloatingBottomNav extends StatefulWidget {
  FloatingBottomNav({super.key});

  @override
  State<FloatingBottomNav> createState() => _FloatingBottomNavState();
}

class _FloatingBottomNavState extends State<FloatingBottomNav> {
  final List navIcons = [
    "asset/button/home.png",
    "asset/button/add.png",
    "asset/button/folder.png"
  ];

  final List navIconsSelected = [
    "asset/button/home_hover.png",
    "asset/button/add_hover.png",
    "asset/button/folder_hover.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
          color: context.read<ThemeProvider>().getSecondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(500.0)),
          boxShadow: [
            BoxShadow(
                color: context.read<ThemeProvider>().getAccentColorWithOpacity,
                offset: const Offset(0, 0),
                blurRadius: 20.0)
          ]),
      child: itemBuilder(context),
    );
  }

  Widget itemBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
          navIcons.length,
          (index) => context.read<Pagecontrollerprovider>().getPageIndex == 0 &&
                  index == 1
              ? const Placeholder(
                  fallbackWidth: 100,
                  color: Colors.transparent,
                )
              : individualNavigationItems(index)),
    );
  }

  Widget individualNavigationItems(int index) {
    String chooseImage() {
      final pageControllerProvidor = context.read<Pagecontrollerprovider>();
      if (pageControllerProvidor.getPageIndex == 0 && index == 0) {
        return navIconsSelected[index];
      } else if (pageControllerProvidor.getPageIndex == 1 && index == 2) {
        return navIconsSelected[index];
      } else {
        return navIcons[index];
      }
    }

    return SizedBox(
        width: 50,
        height: 50,
        child: IconButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            navButtonClicked(index);
          },
          icon: Image.asset(chooseImage()),
        ));
  }

  void navButtonClicked(int index) {
    final itemIndex = index;
    final getPageControllerProvider = context.read<Pagecontrollerprovider>();

    setState(() {
      getPageControllerProvider.setPageIndex = itemIndex;
      getPageControllerProvider.changePage(itemIndex, context);
    });
  }
}
