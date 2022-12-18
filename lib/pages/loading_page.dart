import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project_maintenance_app/models/data_model.dart';
import 'package:project_maintenance_app/utils/helper.dart';
import 'package:project_maintenance_app/main.dart';
import 'package:project_maintenance_app/screens/appsettings/ipaddress.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;

final Image splashLogo = Image.asset('assets/images/splash.png');

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  Future getData(context) async {
    preferences = await SharedPreferences.getInstance();
    bool? useDark = preferences.getBool('useDarkTheme');

    if (useDark != null) changeToDarkTheme(dark: useDark);

    String? savedUrl = preferences.getString('URL');
    bool? loggedIn = preferences.getBool('loggedIn');

    if (savedUrl != null) url = preferences.getString('URL')!;

    loggedIn ??= false;

    await Future.delayed(const Duration(seconds: 0)); // jeda

    if (loggedIn) {
      teknisi = Teknisi.fromJson(jsonDecode(preferences.getString('teknisi')!));
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    getData(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              splashLogo,
              const SpinKitFadingCube(color: Colors.teal),
              const SizedBox(height: 40),
              const Text(
                'Memuat...',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
