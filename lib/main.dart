import 'package:flutter/material.dart';
import 'package:project_maintenance_app/pages/core_page.dart';
import 'package:project_maintenance_app/pages/loading_page.dart';
import 'package:project_maintenance_app/screens/login/login.dart';
import 'package:project_maintenance_app/screens/search_data/search_scan.dart';

void main() {
  runApp(
    ValueListenableBuilder<ThemeMode>(
      valueListenable: currentTheme,
      builder: (ctx, value, _) {
        heroImageNotifier.value = value == ThemeMode.light ? lightHero : darkHero;
        return MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => const LoadingPage(),
            '/login': (context) => const LoginPage(),
            '/home': (context) => const Core(),
          },
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.teal,
            fontFamily: "San Francisco",
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.teal,
            fontFamily: "San Francisco",
          ),
          themeMode: value,
        );
      },
    ),
  );
}

ValueNotifier<ThemeMode> currentTheme = ValueNotifier(ThemeMode.light);

void changeToDarkTheme({bool dark = false}) => dark ? currentTheme.value = ThemeMode.dark : currentTheme.value = ThemeMode.light;
