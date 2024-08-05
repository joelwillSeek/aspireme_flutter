import 'package:aspireme_flutter/Providers/Theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FloatingBottomNav extends StatelessWidget {
  FloatingBottomNav({super.key});

  final List navIcons = [
    "asset/button/home.png",
    "asset/button/add.png",
    "asset/button/folder.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(12),
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
          (index) => SizedBox(
                width: 36,
                height: 36,
                child: GestureDetector(
                  onTap: null,
                  child: Image.asset(
                    navIcons[index],
                    scale: 1.0,
                    width: 50,
                    height: 50,
                  ),
                ),
              )),
    );
  }
}
