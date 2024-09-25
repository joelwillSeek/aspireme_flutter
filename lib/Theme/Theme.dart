import 'package:flutter/material.dart';

final themeLight = ThemeData(
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      unselectedItemColor: Colors.black,
      selectedItemColor: Color.fromARGB(255, 10, 94, 163),
      backgroundColor: Colors.white,
      selectedIconTheme:
          IconThemeData(color: Color.fromARGB(255, 8, 126, 222))),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 10, 94, 163)),
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 220, 220, 220),
      onPrimary: Colors.black,
      secondary: Color.fromARGB(255, 10, 94, 163),
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black),
  textTheme: const TextTheme(headlineMedium: TextStyle(fontSize: 25.0)),
);

final themeDark = ThemeData(
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color.fromARGB(255, 10, 94, 163),
      backgroundColor: Color.fromARGB(255, 29, 29, 29),
      selectedIconTheme:
          IconThemeData(color: Color.fromARGB(255, 8, 126, 222))),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 10, 94, 163)),
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.black,
      onPrimary: Color.fromARGB(255, 255, 255, 255),
      secondary: Color.fromARGB(255, 10, 94, 163),
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: Color.fromARGB(255, 29, 29, 29),
      onSurface: Colors.white),
  textTheme: const TextTheme(),
);
