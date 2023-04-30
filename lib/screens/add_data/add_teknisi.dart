import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_maintenance_app/custom_widget/myBuilder.dart';
import 'package:project_maintenance_app/custom_widget/myFormField.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myTextButton.dart';
import 'package:project_maintenance_app/models/data_model.dart';
import 'package:project_maintenance_app/utils/helper.dart';
import 'package:project_maintenance_app/utils/network.util.dart';

class AddTeknisi extends StatefulWidget {
  const AddTeknisi({super.key});

  @override
  State<AddTeknisi> createState() => _AddTeknisiState();
}

class _AddTeknisiState extends State<AddTeknisi> {
  final formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  var newTeknisi = Teknisi(
    id: '0',
    username: '',
    nama: '',
  );

  var teknisiPassword = '';
  var confirmPassword = '';

  bool passwordVisible = true;
  bool conPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: mxAppBar(title: 'Buat user'),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: mxTextFormField(
                      textController: newTeknisi.nama,
                      labelText: 'Nama Teknisi',
                      onChanged: (value) {
                        newTeknisi.nama = value;
                      },
                      icon: Icons.abc,
                      maxLength: 64,
                      validator: (value) {
                        if (value!.length > 64) {
                          return 'Maks. 64 karakter';
                        } else if (value.isEmpty) {
                          return 'Nama tidak boleh kosong!';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'John doe',
                      autoFocus: true,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: mxTextFormField(
                      textController: newTeknisi.username,
                      labelText: 'Username',
                      onChanged: (value) {
                        newTeknisi.username = value;
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
                      obscure: passwordVisible,
                      textController: teknisiPassword,
                      labelText: 'Kata Sandi',
                      onChanged: (value) {
                        teknisiPassword = value;
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
                    padding: const EdgeInsets.only(top: 15),
                    child: mxTextFormField(
                      focusNode: focusNode,
                      obscure: conPasswordVisible,
                      textController: confirmPassword,
                      labelText: 'Konfirmasi Kata Sandi',
                      onChanged: (value) {
                        confirmPassword = value;
                      },
                      icon: Icons.key,
                      maxLength: 16,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'password tidak boleh kosong!';
                        } else if (value != teknisiPassword) {
                          return 'konfirmasi password tidak sesuai!';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'confirm password',
                      textCapitalization: TextCapitalization.none,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => conPasswordVisible = !conPasswordVisible);
                        },
                        icon: Icon(conPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextButton(
                      icon: Icons.save,
                      buttonPadding: 15,
                      label: 'Simpan',
                      onPress: () {
                        final isValidForm = formKey.currentState!.validate();
                        if (isValidForm) {
                          focusNode.unfocus();
                          setState(
                            () {
                              var route = MaterialPageRoute(
                                builder: (context) => AddTeknisiResult(newTeknisi: newTeknisi, password: teknisiPassword),
                              );
                              Navigator.of(context).push(route);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class AddTeknisiResult extends StatelessWidget {
  const AddTeknisiResult({Key? key, required this.newTeknisi, required this.password}) : super(key: key);

  final Teknisi newTeknisi;
  final String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(
        title: 'Tambah teknisi baru',
        leading: Builder(
          builder: ((context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.maybePop(context);
              },
              tooltip: 'Kembali',
            );
          }),
        ),
      ),
      body: FutureBuilder<bool>(
        future: postData(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return mxDataLoading(text: 'Sending data...');
            case ConnectionState.done:
            default:
              if (snapshot.hasData) {
                Future.delayed(const Duration(seconds: 5)).then((value) => Navigator.of(context).popUntil((route) => route.isFirst));
                return mxErrorFuture(
                  icon: Icons.check,
                  iconColor: Colors.green,
                  textColor: Colors.blue,
                  snapshotErr: 'Buat user berhasil',
                  labelBtn: 'Kembali',
                  iconRefresh: Icons.arrow_back_outlined,
                  onPress: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                );
              } else if (snapshot.hasError) {
                if (snapshot.error.toString() == errorConnection) {
                  return mxErrorFuture(
                    snapshotErr: snapshot.error.toString(),
                    labelBtn: 'Coba lagi',
                    onPress: () {
                      var route = MaterialPageRoute(
                        builder: (BuildContext context) => AddTeknisiResult(newTeknisi: newTeknisi, password: password),
                      );

                      Navigator.of(context).pushReplacement(route);
                    },
                  );
                } else {
                  return mxErrorFuture(
                    icon: Icons.do_not_disturb_alt_outlined,
                    snapshotErr: '${snapshot.error}',
                    labelBtn: 'Kembali',
                    iconRefresh: Icons.arrow_back_outlined,
                    onPress: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  );
                }
              }
          }
          return mxDataLoading(text: 'Sending data...');
        }),
      ),
    );
  }

  Future<bool>? postData() async {
    final http.Response response = await queryData(
      httpVerbs: httpPOST,
      context: ctxTeknisi,
      action: actCreate,
      body: {
        'username': newTeknisi.username,
        'nama_teknisi': newTeknisi.nama,
        'password': password,
      },
    );

    if (kDebugMode) {
      print(response.body.toString());
    }

    if (int.parse(response.body) == 1) {
      return true;
    } else {
      throw Exception('Gagal insert ke database atau data sudah ada');
    }
  }
}
