import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_maintenance_app/models/data_model.dart';
import 'package:project_maintenance_app/custom_widget/myBuilder.dart';
import 'package:project_maintenance_app/custom_widget/myFormField.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myTextButton.dart';
import 'package:project_maintenance_app/utils/helper.dart';
import 'package:project_maintenance_app/utils/network.util.dart';

class AddRuangan extends StatefulWidget {
  const AddRuangan({Key? key}) : super(key: key);

  @override
  State<AddRuangan> createState() => _AddRuanganState();
}

class _AddRuanganState extends State<AddRuangan> {
  final formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  Ruangan newRuangan = Ruangan(id: '', namaRuangan: '', kode: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(
        title: 'Tambah ruangan baru',
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.maybePop(context);
              },
              tooltip: 'Kembali',
            );
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextFormField(
                      textController: newRuangan.namaRuangan,
                      labelText: 'Nama ruangan',
                      onChanged: (value) {
                        newRuangan.namaRuangan = value;
                      },
                      icon: Icons.home_outlined,
                      maxLength: 16,
                      validator: (value) {
                        if (value!.length > 16) {
                          return 'Maks. 16 karakter';
                        } else if (value.isEmpty) {
                          return 'Nama ruangan tidak boleh kosong!';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'Ruangan',
                      autoFocus: true,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextFormField(
                      focusNode: focusNode,
                      textController: newRuangan.kode,
                      labelText: 'Kode ruangan',
                      onChanged: (value) {
                        newRuangan.kode = value;
                      },
                      icon: Icons.code_outlined,
                      maxLength: 3,
                      validator: (value) {
                        if (value!.length > 3) {
                          return 'Maks. 3 karakter';
                        } else if (value.isEmpty) {
                          return 'Kode ruangan tidak boleh kosong!';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'Contoh : FS',
                      // autoFocus: true,
                      textCapitalization: TextCapitalization.characters,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextButtonNoIcon(
                      buttonPadding: 15,
                      label: 'Simpan',
                      onPress: () {
                        final isValidForm = formKey.currentState!.validate();

                        if (!isValidForm) return;

                        focusNode.unfocus();
                        setState(() {
                          var route = MaterialPageRoute(builder: (BuildContext context) => AddRuanganResult(newRuangan: newRuangan));
                          Navigator.of(context).push(route);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddRuanganResult extends StatefulWidget {
  const AddRuanganResult({Key? key, required this.newRuangan}) : super(key: key);

  final Ruangan newRuangan;

  @override
  State<AddRuanganResult> createState() => _AddRuanganResultState();
}

class _AddRuanganResultState extends State<AddRuanganResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(
        title: 'Tambah ruangan baru',
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
      body: FutureBuilder<String>(
        future: postData(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return mxDataLoading(text: 'Sending data...');
            case ConnectionState.done:
            default:
              if (snapshot.hasData) {
                return mxErrorFuture(
                  icon: Icons.check,
                  iconColor: Colors.green,
                  textColor: Colors.blue,
                  snapshotErr: 'Insert data berhasil',
                  labelBtn: 'Lihat data',
                  iconRefresh: Icons.home_outlined,
                  onPress: () {
                    setState(() {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    });
                  },
                );
              } else if (snapshot.hasError) {
                if (snapshot.error.toString() == errorConnection) {
                  return mxErrorFuture(
                    snapshotErr: snapshot.error.toString(),
                    labelBtn: 'Coba lagi',
                    onPress: () {
                      setState(() {
                        var route = MaterialPageRoute(
                          builder: (BuildContext context) => AddRuanganResult(newRuangan: widget.newRuangan),
                        );

                        Navigator.of(context).pushReplacement(route);
                      });
                    },
                  );
                } else {
                  return mxErrorFuture(
                    icon: Icons.do_not_disturb_alt_outlined,
                    snapshotErr: '${snapshot.error}',
                    labelBtn: 'Lihat data',
                    iconRefresh: Icons.list,
                    onPress: () {
                      setState(() {
                        // var route = MaterialPageRoute(
                        //   builder: (BuildContext context) => const DataRuangan(),
                        // );
                        // Navigator.of(context).pushReplacement(route);
                        // int count = 0;
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      });
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

  Future<String>? postData() async {
    final http.Response response = await queryData(
      httpVerbs: httpPOST,
      context: ctxRuangan,
      action: actCreate,
      body: {
        'nama_ruangan': widget.newRuangan.namaRuangan,
        'kode': widget.newRuangan.kode,
      },
    );

    if (int.parse(response.body) == 1) {
      return int.parse(response.body).toString();
    } else {
      throw Exception('Gagal insert ke database atau data sudah ada');
    }
  }
}
