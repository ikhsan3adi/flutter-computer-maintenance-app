import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_maintenance_app/customClasses/data.dart';
import 'package:project_maintenance_app/customClasses/myBuilder.dart';
import 'package:project_maintenance_app/customClasses/myScaffold.dart';
import 'package:project_maintenance_app/customClasses/myTextButton.dart';
import 'package:project_maintenance_app/customClasses/myFormField.dart';
import 'package:project_maintenance_app/pages/appsettings/ipaddress.dart';
import 'package:project_maintenance_app/pages/manageData/ruangan_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({Key? key, required this.ruangan}) : super(key: key);

  final String ruangan;

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final formKey = GlobalKey<FormState>();

  String placeholderRuangan = 'Pilih ruangan';

  Perangkat newPerangkat = Perangkat(
    kodeUnit: '',
    namaUser: '',
    namaUnit: '',
    type: '',
    ruangan: '',
    keterangan: '',
  );

  @override
  Widget build(BuildContext context) {
    // List<String> ruangan = dummyRuangan.map((e) => e.namaRuangan).toList();
    List<String> ruangan = realRuangan.map((e) => e.namaRuangan).toList();
    ruangan.insert(0, placeholderRuangan);

    return Scaffold(
      appBar: mxAppBar(
        title: 'Tambah perangkat baru',
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
                      textController: newPerangkat.namaUser,
                      labelText: 'Nama user',
                      onChanged: (value) {
                        newPerangkat.namaUser = value;
                      },
                      icon: Icons.person,
                      maxLength: 32,
                      validator: (value) {
                        if (value!.length > 32) {
                          return 'Maks. 32 karakter';
                        } else if (value.isEmpty) {
                          return 'Nama user tidak boleh kosong!';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'Pengguna',
                      autoFocus: true,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextFormField(
                      textController: newPerangkat.namaUnit,
                      labelText: 'Nama unit',
                      onChanged: (value) {
                        newPerangkat.namaUnit = value;
                      },
                      icon: Icons.computer_sharp,
                      maxLength: 32,
                      validator: (value) {
                        if (value!.length > 32) {
                          return 'Maks. 32 karakter';
                        } else if (value.isEmpty) {
                          return 'Nama unit tidak boleh kosong!';
                        } else {
                          return null;
                        }
                      },
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextFormField(
                      textController: newPerangkat.type,
                      labelText: 'Type',
                      icon: Icons.type_specimen_outlined,
                      onChanged: (value) {
                        newPerangkat.type = value;
                      },
                      maxLength: 32,
                      validator: (value) {
                        if (value!.length > 32) {
                          return 'Maks. 32 karakter';
                        } else if (value.isEmpty) {
                          return 'Type unit tidak boleh kosong!';
                        } else {
                          return null;
                        }
                      },
                      textCapitalization: TextCapitalization.characters,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: DropdownButtonFormField<String>(
                      validator: (value) {
                        if (value == placeholderRuangan) {
                          return 'Silakan pilih ruangan';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.home),
                        label: Text('Ruangan'),
                      ),
                      value: widget.ruangan,
                      items: ruangan.map((e) {
                        return DropdownMenuItem<String>(value: e, child: Text(e));
                      }).toList(),
                      onSaved: (value) {
                        return setState(() {
                          newPerangkat.ruangan = value!;
                        });
                      },
                      onChanged: (value) {
                        return setState(() {
                          newPerangkat.ruangan = value!;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: mxTextFormField(
                      textController: newPerangkat.keterangan,
                      labelText: 'Keterangan',
                      icon: Icons.more,
                      onChanged: (value) {
                        newPerangkat.keterangan = value;
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
                                builder: (BuildContext context) => AddDeviceResult(
                                  newPerangkat: newPerangkat,
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

class AddDeviceResult extends StatefulWidget {
  const AddDeviceResult({Key? key, required this.newPerangkat}) : super(key: key);

  final Perangkat newPerangkat;

  @override
  State<AddDeviceResult> createState() => _AddDeviceResultState();
}

class _AddDeviceResultState extends State<AddDeviceResult> {
  Future<String>? postData() async {
    final uri = Uri(scheme: 'http', host: iPAddress, path: 'MxData_device/createNewPerangkat/', queryParameters: {
      'nama_user': widget.newPerangkat.namaUser,
      'nama_unit': widget.newPerangkat.namaUnit,
      'type': widget.newPerangkat.type,
      'ruangan': widget.newPerangkat.ruangan,
      'keterangan': widget.newPerangkat.keterangan
    });

    final Response response;
    try {
      response = await get(uri);
    } catch (e) {
      throw Exception(errorConnection);
    }

    if (int.parse(response.body) == 0) {
      throw Exception('Gagal insert ke database');
    } else {
      return response.body;
    }
  }

  Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    String qrData = '';
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
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<String>(
            future: postData(),
            builder: ((context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return mxDataLoading(text: 'Sending data...');
                case ConnectionState.done:
                default:
                  if (snapshot.hasData) {
                    qrData = snapshot.data!;
                    return Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 80,
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Insert data berhasil',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                        qrView(qrData: qrData, textUser: widget.newPerangkat.namaUser),
                        const SizedBox(height: 15),
                        mxTextButton(
                          label: 'Simpan QR ke galeri',
                          labelFontSize: 16,
                          buttonPadding: 15,
                          onPress: () async {
                            final sScontroller = ScreenshotController();
                            final bytes =
                                await sScontroller.captureFromWidget(Material(child: qrView(qrData: qrData, textUser: widget.newPerangkat.namaUser)));

                            this.bytes = bytes;
                            saveImage(bytes);
                          },
                          icon: Icons.save_outlined,
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    if (snapshot.error.toString() == errorConnection) {
                      return mxErrorFuture(
                        snapshotErr: snapshot.error.toString(),
                        labelBtn: 'Coba lagi',
                        onPress: () {
                          setState(() {
                            var route = MaterialPageRoute(
                              builder: (BuildContext context) => AddDeviceResult(newPerangkat: widget.newPerangkat),
                            );

                            Navigator.of(context).pushReplacement(route);
                          });
                        },
                      );
                    } else {
                      return mxErrorFuture(
                        icon: Icons.do_not_disturb_alt_outlined,
                        snapshotErr: '${snapshot.error}',
                        labelBtn: 'Beranda',
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
      ),
    );
  }

  Future saveImage(Uint8List bytes) async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      return;
    }
    final appStorage = await getExternalStorageDirectory();
    final file = File('${appStorage!.path}/qrDevice/image.png');
    file.writeAsBytes(bytes);
  }
}

Widget qrView({required String qrData, required textUser}) {
  return Card(
    child: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          QrImage(
            padding: const EdgeInsets.all(0),
            data: qrData,
            size: 200,
          ),
          blueBigText(
            text: qrData,
            color: Colors.black,
            size: 24,
          ),
          Text(
            'User : $textUser',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    ),
  );
}
