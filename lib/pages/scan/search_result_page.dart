// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:project_maintenance_app/customClasses/data.dart';
import 'package:project_maintenance_app/customClasses/myBuilder.dart';
import 'package:project_maintenance_app/customClasses/myTextButton.dart';
import 'package:project_maintenance_app/pages/appsettings/ipaddress.dart';
import 'package:project_maintenance_app/pages/manageData/add_perawatan_page.dart';
import 'package:project_maintenance_app/pages/manageData/dataPerawatan_page.dart';
import 'package:project_maintenance_app/pages/scan/home.dart';

Future<Perangkat?> searchPerangkat(String kodeUnit) async {
  // search qr result in database
  Uri jsonEndPoint = Uri(
    scheme: 'http',
    host: iPAddress,
    path: '$apiPath/getPerangkat/',
    queryParameters: {'kode_unit': kodeUnit},
  );

  Response response = await get(jsonEndPoint);

  try {
    List device = json.decode(response.body);
    List<Perangkat> p = device.map((device) => Perangkat.fromJson(device)).toList();

    return p[0];
  } catch (e) {
    throw Exception(errorDataEmpty);
  }
  // for (var element in dummyPerangkat) {
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   if (element.kodeUnit == kodeUnit) {
  //     return element;
  //   }
  // }
  // return null;
}

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key, required this.kodeUnit}) : super(key: key);

  final String kodeUnit;

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.maybePop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Text('Cari data'),
        centerTitle: true,
        foregroundColor: Colors.blueAccent,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Perangkat?>(
          future: searchPerangkat(widget.kodeUnit),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: blueBigText(
                        text: 'Data berhasil ditemukan',
                        size: 16,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 15.0,
                        ),
                        Card(
                          child: Column(
                            children: [
                              ExpansionTile(
                                initiallyExpanded: true,
                                title: blueBigText(text: 'Kode unit'),
                                subtitle: Text(snapshot.data!.kodeUnit),
                                children: [
                                  perangkatTile(
                                    title: 'User',
                                    trail: snapshot.data!.namaUser,
                                  ),
                                  perangkatTile(
                                    title: 'Ruangan',
                                    trail: snapshot.data!.ruangan,
                                  ),
                                  perangkatTile(
                                    title: 'Nama unit',
                                    trail: snapshot.data!.namaUnit,
                                  ),
                                  perangkatTile(
                                    title: 'Type',
                                    trail: snapshot.data!.type,
                                  ),
                                  perangkatTile(
                                    title: 'Keterangan',
                                    trail: snapshot.data!.keterangan,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              mxTextButtonNoIcon(
                                buttonPadding: 15,
                                label: 'Tambah data perawatan',
                                hasOutline: false,
                                onPress: () {
                                  var route = MaterialPageRoute(builder: (context) {
                                    return AddPerawatan(perangkat: snapshot.data!);
                                  });
                                  Navigator.of(context).push(route);
                                },
                              ),
                              const SizedBox(height: 15),
                              mxTextButtonNoIcon(
                                buttonPadding: 15,
                                label: 'Lihat data perawatan',
                                hasOutline: false,
                                onPress: () {
                                  var route = MaterialPageRoute(builder: (context) {
                                    return DataPerawatan(device: snapshot.data!);
                                  });
                                  Navigator.of(context).push(route);
                                },
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(
                        //   height: 80.0,
                        // ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: SingleChildScrollView(
                  child: mxErrorFuture(
                    snapshotErr: '${snapshot.error.toString()} "${widget.kodeUnit}"',
                    textColor: Colors.grey,
                    icon: Icons.search_off_outlined,
                    iconRefresh: Icons.add_link_outlined,
                    labelBtn: 'Masukkan ulang kode',
                    onPress: () async {
                      final kodeUnit = await openInsertCodeDialog(context: context, controller: controller);
                      setState(() {
                        if (kodeUnit == null || kodeUnit == '') {
                          const SnackBar(
                            content: Text('Input tidak boleh kosong!'),
                          );
                        } else {
                          setState(() {
                            var route = MaterialPageRoute(
                              builder: (BuildContext context) => SearchResultPage(
                                kodeUnit: kodeUnit,
                              ),
                            );
                            Navigator.of(context).pushReplacement(route);
                          });
                        }
                      });
                    },
                    secondButton: true,
                    labelBtn2: 'Scan ulang',
                    iconBtn2: Icons.qr_code_2_outlined,
                    onPress2: () async {
                      ScanResult codeScanner = await BarcodeScanner.scan(); //barcode scanner
                      if (codeScanner.rawContent != '') {
                        var route = MaterialPageRoute(
                          builder: (BuildContext context) => SearchResultPage(
                            kodeUnit: codeScanner.rawContent,
                          ),
                        );
                        Navigator.of(context).pushReplacement(route);
                      } else {
                        return;
                      }
                    },
                  ),
                ),
              );
            }
            return Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Mencari',
                        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        widget.kodeUnit,
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 80.0,
                      ),
                      const SpinKitFoldingCube(
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(
                        height: 80.0,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

Widget perangkatTile({required title, required trail, Color? titleColor = Colors.blueAccent, Color? trailColor = Colors.black87}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
    title: Text(
      title,
      style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
    ),
    trailing: Text(
      trail,
      style: TextStyle(color: trailColor),
    ),
  );
}
