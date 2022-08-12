// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project_maintenance_app/pages/appsettings/ipaddress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

late SharedPreferences preferences;

class _LoadingState extends State<Loading> {
  Future getData() async {
    preferences = await SharedPreferences.getInstance();

    String? ip = preferences.getString('IP');

    if (ip != null) {
      iPAddress = preferences.getString('IP')!;
    }

    // replace future with connection checking
    await Future.delayed(const Duration(milliseconds: 1500));

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SpinKitFadingCube(
                color: Colors.blueAccent,
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
