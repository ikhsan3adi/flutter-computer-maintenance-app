import 'package:flutter/material.dart';
import 'package:project_maintenance_app/pages/core_page.dart';
import 'package:project_maintenance_app/pages/loading_page.dart';
import 'package:project_maintenance_app/screens/login/login.dart';
import 'package:project_maintenance_app/screens/search_data/search_scan.dart';

// variabel untuk menyimpan tema aplikasi saat ini
ValueNotifier<ThemeMode> currentTheme = ValueNotifier(ThemeMode.light);

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
            '/home': (context) => Core(),
          },
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.teal,
            fontFamily: "San Francisco",
            visualDensity: VisualDensity.standard,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.teal,
            fontFamily: "San Francisco",
            visualDensity: VisualDensity.standard,
          ),
          themeMode: value,
        );
      },
    ),
  );
}

// function untuk mengubah tema aplikasi
void changeToDarkTheme({bool dark = false}) => dark ? currentTheme.value = ThemeMode.dark : currentTheme.value = ThemeMode.light;
