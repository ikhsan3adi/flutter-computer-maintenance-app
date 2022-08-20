import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:project_maintenance_app/customClasses/data.dart';
import 'package:project_maintenance_app/customClasses/myBuilder.dart';
import 'package:project_maintenance_app/customClasses/myScaffold.dart';
import 'package:project_maintenance_app/customClasses/myTextButton.dart';
import 'package:project_maintenance_app/pages/appsettings/ipaddress.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class AddDeviceResult extends StatefulWidget {
  const AddDeviceResult({Key? key, required this.newPerangkat}) : super(key: key);

  final Perangkat newPerangkat;

  @override
  State<AddDeviceResult> createState() => _AddDeviceResultState();
}

class _AddDeviceResultState extends State<AddDeviceResult> {
  Future<String>? postData() async {
    final uri = Uri(
      scheme: 'http',
      host: iPAddress,
      path: '$apiPath/createNewPerangkat/',
      queryParameters: {
        'nama_user': widget.newPerangkat.namaUser,
        'nama_unit': widget.newPerangkat.namaUnit,
        'type': widget.newPerangkat.type,
        'ruangan': widget.newPerangkat.ruangan,
        'keterangan': widget.newPerangkat.keterangan
      },
    );

    final http.Response response;
    try {
      response = await http.get(uri);
    } catch (e) {
      throw Exception(errorConnection);
    }

    if (response.body.toString() == 'error') {
      throw Exception('Gagal insert ke database');
    } else {
      String kodeUnit = response.body.trim();

      widget.newPerangkat.kodeUnit = kodeUnit;
      final sScontroller = ScreenshotController();

      final Uint8List bytes = await sScontroller.captureFromWidget(
        Material(child: qrView(qrData: kodeUnit, textUser: widget.newPerangkat.namaUser, elevation: 0)),
      );
      saveImage(bytes, widget.newPerangkat);
      return kodeUnit;
    }
  }

  @override
  Widget build(BuildContext context) {
    String qrData;

    return Scaffold(
      appBar: mxAppBar(
        title: 'Tambah perangkat baru',
        leading: Builder(
          builder: (context) {
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
                          label: 'Lihat data',
                          labelFontSize: 16,
                          buttonPadding: 15,
                          onPress: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          icon: Icons.list,
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

  Future saveImage(Uint8List bytes, Perangkat perangkat) async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();
    var date = DateTime.now().day.toString();

    var time = "$date-$month-$year";

    String fileName = '${perangkat.kodeUnit}_${perangkat.namaUser}_$time.png';

    String baseImage = base64Encode(bytes);

    Uri uploadUrl = Uri(
      scheme: 'http',
      host: iPAddress,
      path: '$apiPath/saveQR.php',
      // queryParameters: {
      //   "name": fileName,
      // },
    );

    var response = await http.post(
      uploadUrl,
      body: {
        "image": baseImage,
        "name": fileName.toString(),
      },
    );

    if (response.statusCode == 200) {
      if (response.body.toString() == '0') {
        Fluttertoast.showToast(msg: 'Gagal menyimpan QR ke server\nFile bermasalah');
      } else {
        Fluttertoast.showToast(msg: 'Berhasil menyimpan QR ke server');
      }
      // print(response.body.toString());
    } else {
      Fluttertoast.showToast(msg: 'Gagal terhubung ke server');
      // print("Error during connection to server");
    }
  }
}

Widget qrView({required String qrData, required textUser, double elevation = 1.0}) {
  return SingleChildScrollView(
    child: Card(
      elevation: elevation,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            QrImage(
              padding: const EdgeInsets.all(0),
              data: qrData,
              size: 200,
            ),
            const SizedBox(height: 20),
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
    ),
  );
}
