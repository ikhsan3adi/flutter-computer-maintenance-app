import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project_maintenance_app/data/data_model.dart';
import 'package:project_maintenance_app/data/helper.dart';
import 'package:project_maintenance_app/main.dart';
import 'package:project_maintenance_app/screens/appsettings/ipaddress.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;

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
            children: const [
              SpinKitFadingCube(
                color: Colors.teal,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Memuat...',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
