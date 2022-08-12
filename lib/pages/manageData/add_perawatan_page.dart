import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_maintenance_app/customClasses/data.dart';
import 'package:project_maintenance_app/customClasses/myBuilder.dart';
import 'package:project_maintenance_app/customClasses/myScaffold.dart';
import 'package:project_maintenance_app/customClasses/myTextButton.dart';
import 'package:project_maintenance_app/customClasses/myFormField.dart';
import 'package:project_maintenance_app/pages/appsettings/ipaddress.dart';

class AddPerawatan extends StatefulWidget {
  const AddPerawatan({Key? key, required this.perangkat}) : super(key: key);

  final Perangkat perangkat;

  @override
  State<AddPerawatan> createState() => _AddPerawatanState();
}

class _AddPerawatanState extends State<AddPerawatan> {
  final formKey = GlobalKey<FormState>();

  late Perawatan newPerawatan = Perawatan(
    id: 0,
    kodeUnit: '',
    tanggal: '',
    pembersihan: false,
    pengecekanChipset: false,
    scanVirus: false,
    pembersihanTemporary: false,
    pengecekanSoftware: false,
    installUpdateDriver: false,
    keterangan: '',
    teknisi: '',
  );

  @override
  Widget build(BuildContext context) {
    var currentTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    var y = currentTime.toString().substring(0, 4);
    var m = currentTime.toString().substring(5, 7);
    var d = currentTime.toString().substring(8, 10);

    // ignore: avoid_print
    print('$y-$d-$m');

    newPerawatan.kodeUnit = widget.perangkat.kodeUnit;
    newPerawatan.tanggal = '$y-$d-$m';

    return Scaffold(
      appBar: mxAppBar(
        title: 'Data perawatan baru',
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
              Card(
                child: Row(
                  children: [
                    Flexible(
                      child: ListTile(
                        title: blueBigText(text: 'Kode : ${widget.perangkat.kodeUnit}', size: 16),
                        subtitle: Text('User :  ${widget.perangkat.namaUser}'),
                      ),
                    ),
                    Flexible(
                      child: ListTile(
                        title: blueBigText(text: 'Unit : ${widget.perangkat.namaUnit}', size: 16, align: TextAlign.end),
                        subtitle: Text(
                          'Type :  ${widget.perangkat.type}',
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 15),
                  mxTextFormField(
                    textController: newPerawatan.teknisi,
                    labelText: 'Nama teknisi',
                    icon: Icons.person_search,
                    onChanged: (v) {
                      newPerawatan.teknisi = v!;
                    },
                    validator: (value) {
                      if (value!.length > 32) {
                        return 'Maks. 32 karakter';
                      } else if (value.isEmpty) {
                        return 'Nama teknisi tidak boleh kosong!';
                      } else {
                        return null;
                      }
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Column(
                        children: [
                          mXcheckBoxListTile(
                              title: 'Pembersihan komponen komputer',
                              onChanged: (v) {
                                setState(() {
                                  newPerawatan.pembersihan = v!;
                                });
                              },
                              value: newPerawatan.pembersihan),
                          const SizedBox(height: 5),
                          mXcheckBoxListTile(
                              title: 'Pengecekan dan pemberian pasta pada chipset',
                              onChanged: (v) {
                                setState(() {
                                  newPerawatan.pengecekanChipset = v!;
                                });
                              },
                              value: newPerawatan.pengecekanChipset),
                          const SizedBox(height: 5),
                          mXcheckBoxListTile(
                              title: 'Scan virus + update',
                              onChanged: (v) {
                                setState(() {
                                  newPerawatan.scanVirus = v!;
                                });
                              },
                              value: newPerawatan.scanVirus),
                          const SizedBox(height: 5),
                          mXcheckBoxListTile(
                              title: 'Pembersihan sampah binary dan temporary files',
                              onChanged: (v) {
                                setState(() {
                                  newPerawatan.pembersihanTemporary = v!;
                                });
                              },
                              value: newPerawatan.pembersihanTemporary),
                          const SizedBox(height: 5),
                          mXcheckBoxListTile(
                              title: 'Perawatan dan pengecekan software yang terinstall',
                              onChanged: (v) {
                                setState(() {
                                  newPerawatan.pengecekanSoftware = v!;
                                });
                              },
                              value: newPerawatan.pengecekanSoftware),
                          const SizedBox(height: 5),
                          mXcheckBoxListTile(
                              title: 'Install, update, dan konfigurasi driver',
                              onChanged: (v) {
                                setState(() {
                                  newPerawatan.installUpdateDriver = v!;
                                });
                              },
                              value: newPerawatan.installUpdateDriver),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextFormField(
                      textController: newPerawatan.keterangan,
                      labelText: 'Keterangan',
                      icon: Icons.more,
                      onChanged: (value) {
                        newPerawatan.keterangan = value;
                      },
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextButtonNoIcon(
                      buttonPadding: 20,
                      hasOutline: false,
                      label: 'Simpan',
                      onPress: () {
                        final isValidForm = formKey.currentState!.validate();
                        if (isValidForm) {
                          setState(
                            () {
                              var route = MaterialPageRoute(
                                builder: (BuildContext context) => AddPerawatanResult(
                                  newPerawatan: newPerawatan,
                                ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class AddPerawatanResult extends StatefulWidget {
  const AddPerawatanResult({Key? key, required this.newPerawatan}) : super(key: key);

  final Perawatan newPerawatan;

  @override
  State<AddPerawatanResult> createState() => _AddPerawatanResultState();
}

class _AddPerawatanResultState extends State<AddPerawatanResult> {
  Future<String>? postData() async {
    final uri = Uri(
      scheme: 'http',
      host: iPAddress,
      path: 'MxData_device/createNewPerawatan/',
      queryParameters: {
        'kode_unit': widget.newPerawatan.kodeUnit,
        'tanggal_pengecekan': widget.newPerawatan.tanggal,
        'pembersihan': boolToStr(widget.newPerawatan.pembersihan),
        'pengecekan_chipset': boolToStr(widget.newPerawatan.pengecekanChipset),
        'scan_virus': boolToStr(widget.newPerawatan.scanVirus),
        'pembersihan_temporary': boolToStr(widget.newPerawatan.pembersihanTemporary),
        'pengecekan_software': boolToStr(widget.newPerawatan.pengecekanSoftware),
        'install_update_driver': boolToStr(widget.newPerawatan.installUpdateDriver),
        'keterangan': widget.newPerawatan.keterangan,
        'nama_teknisi': widget.newPerawatan.teknisi,
      },
    );

    final Response response;
    try {
      response = await post(uri);
    } catch (e) {
      throw Exception(errorConnection);
    }

    if (int.parse(response.body) == 1) {
      return int.parse(response.body).toString();
    } else {
      throw Exception('Gagal insert ke database');
    }
  }

  late Future<String>? myFuture = postData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(
        title: 'Tambah perangkat baru',
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
      body: SingleChildScrollView(
        child: FutureBuilder<String>(
          future: myFuture,
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
                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
                    },
                  );
                } else if (snapshot.hasError) {
                  if (snapshot.error.toString() == errorConnection) {
                    return mxErrorFuture(
                      snapshotErr: snapshot.error.toString(),
                      labelBtn: 'Coba lagi',
                      onPress: () {
                        setState(() {
                          myFuture = postData();
                        });
                      },
                    );
                  } else {
                    return mxErrorFuture(
                      icon: Icons.do_not_disturb_alt_outlined,
                      snapshotErr: '${snapshot.error}',
                      labelBtn: 'Lihat data',
                      iconRefresh: Icons.home_outlined,
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
      ),
    );
  }
}

Widget mXcheckBoxListTile({required title, required Function(bool?)? onChanged, required bool value}) {
  return CheckboxListTile(
    title: Text(
      title,
      style: TextStyle(color: value ? Colors.blue : Colors.grey[800]),
    ),
    onChanged: onChanged,
    value: value,
  );
}
