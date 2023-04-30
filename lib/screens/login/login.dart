// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:project_maintenance_app/custom_widget/myDrawer.dart';
import 'package:project_maintenance_app/custom_widget/myFormField.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myTextButton.dart';
import 'package:project_maintenance_app/models/data_model.dart';
import 'package:project_maintenance_app/pages/core_page.dart';
import 'package:project_maintenance_app/utils/helper.dart';
import 'package:project_maintenance_app/utils/network.util.dart';
import 'package:project_maintenance_app/main.dart';
import 'package:project_maintenance_app/screens/appsettings/ipaddress.dart';
import 'package:project_maintenance_app/pages/loading_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  late Widget loginLoading = const SizedBox.shrink();

  String loginFailedText = '';

  late String username = '';
  late String password = '';

  bool passwordVisible = true;

  bool asAdmin = false;

  String type = ctxTeknisi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(title: 'Login'),
      drawer: mxDrawer(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(loginFailedText, style: const TextStyle(color: Colors.red)),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: mxTextFormField(
                        textController: username,
                        labelText: 'Username',
                        onChanged: (value) {
                          username = value;
                        },
                        icon: Icons.person,
                        maxLength: 16,
                        validator: (value) {
                          if (value!.length > 16) {
                            return 'Maks. 16 karakter';
                          } else if (value.isEmpty) {
                            return 'username tidak boleh kosong!';
                          } else {
                            return null;
                          }
                        },
                        hintText: 'lorem123',
                        textCapitalization: TextCapitalization.none,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: mxTextFormField(
                        focusNode: focusNode,
                        obscure: passwordVisible,
                        textController: password,
                        labelText: 'Kata Sandi',
                        onChanged: (value) {
                          password = value;
                        },
                        icon: Icons.key,
                        maxLength: 16,
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'Sandi Min. 6 karakter';
                          } else if (value!.length > 16) {
                            return 'Sandi Maks. 16 karakter';
                          } else if (value.isEmpty) {
                            return 'password tidak boleh kosong!';
                          } else {
                            return null;
                          }
                        },
                        hintText: 'password',
                        textCapitalization: TextCapitalization.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() => passwordVisible = !passwordVisible);
                          },
                          icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: mxTextButton(
                        icon: Icons.login,
                        buttonPadding: 15,
                        label: 'Masuk  ',
                        onPress: () async {
                          final isValidForm = formKey.currentState!.validate();
                          if (isValidForm) {
                            focusNode.unfocus();
                            try {
                              bool loginSuccess = await login();

                              if (loginSuccess) {
                                preferences.setBool('loggedIn', true);
                                Navigator.of(context).pushReplacementNamed('/home');
                              } else {
                                setState(() {
                                  loginFailedText = 'Login gagal, username / password salah';
                                  loginLoading = const SizedBox.shrink();
                                });
                              }
                            } catch (e) {
                              setState(() {
                                loginFailedText = 'Tidak bisa konek ke server atau Url Address salah';
                                loginLoading = const SizedBox.shrink();
                              });
                            }
                          }
                        },
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                        title: const Text('Login sebagai admin'),
                        trailing: Switch.adaptive(
                            value: asAdmin,
                            onChanged: (value) {
                              setState(() {
                                asAdmin = !asAdmin;
                                if (!value) {
                                  type = ctxTeknisi;
                                } else {
                                  type = 'admin';
                                }
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          loginLoading,
        ],
      ),
    );
  }

  Future<bool> login() async {
    setState(() => loginLoading = loadingWidget());

    final http.Response response = await queryData(
      httpVerbs: httpPOST,
      context: ctxTeknisi,
      action: actLogin,
      body: {
        'username': username,
        'password': password,
        'type': type,
      },
    );

    await Future.delayed(const Duration(seconds: 2));

    if (kDebugMode) {
      print(response.body.toString());
      print(teknisi.nama);
    }

    try {
      if (response.body == '0') {
        // login gagal jika response = '0'
        return false;
      } else {
        teknisi = Teknisi.fromJson(jsonDecode(response.body.toString()));
        preferences.setString('teknisi', response.body.toString());

        type == 'admin' ? admin = true : admin = false;

        return true;
      }
    } catch (e) {
      throw Exception(errorConnection);
    }
  }

  Widget mxDrawer() {
    return Drawer(
      backgroundColor: Colors.teal,
      child: SafeArea(
        child: Material(
          child: ListView(
            children: [
              const SizedBox(height: 10),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: currentTheme,
                builder: ((context, value, _) => mxBuildMenuItem(
                      icon: Icons.dark_mode,
                      titleText: 'Mode Gelap',
                      trailing: Switch.adaptive(
                        value: currentTheme.value == ThemeMode.dark,
                        onChanged: (v) {
                          changeToDarkTheme(dark: v);
                        },
                      ),
                    )),
              ),
              const Divider(thickness: 1),
              mxBuildMenuItem(
                icon: Icons.signal_wifi_4_bar_lock,
                titleText: 'Ubah URL Server',
                subtitle: url,
                onClicked: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const IPAddressPage()))).then((_) => setState(() {}));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget loadingWidget() {
  return Stack(
    children: [
      Container(color: const Color.fromARGB(75, 0, 0, 0)),
      Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SpinKitFoldingCube(color: Colors.white),
            SizedBox(height: 40),
            Text(
              'Login...',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    ],
  );
}
