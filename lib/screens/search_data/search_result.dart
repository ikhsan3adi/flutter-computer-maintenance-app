// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/mycolor.dart';
import 'package:project_maintenance_app/models/data_model.dart';
import 'package:project_maintenance_app/custom_widget/myBuilder.dart';
import 'package:project_maintenance_app/custom_widget/myTextButton.dart';
import 'package:project_maintenance_app/utils/helper.dart';
import 'package:project_maintenance_app/utils/network.util.dart';
import 'package:project_maintenance_app/screens/add_data/add_perawatan/add_perawatan.dart';
import 'package:project_maintenance_app/screens/show_data/dataPerawatan.dart';
import 'package:project_maintenance_app/screens/search_data/search_scan.dart';

fetchDataTeknisi() async {
  http.Response? response = await queryData(httpVerbs: httpGET, context: ctxTeknisi, action: actSelect);

  try {
    List teknisi = json.decode(response.body);
    listTeknisi = teknisi.map((teknisi) => Teknisi.fromJson(teknisi)).toList();
  } catch (e) {
    throw Exception(errorDataEmpty);
  }
}

Future<Perangkat?> searchPerangkat(String kodeUnit) async {
  // search qr result in database
  http.Response response = await queryData(httpVerbs: httpGET, context: ctxDevice, action: actSelect, extraQueryParameters: {'kode_unit': kodeUnit});

  try {
    List device = json.decode(response.body);
    List<Perangkat> p = device.map((device) => Perangkat.fromJson(device)).toList();

    return p[0];
  } catch (e) {
    throw Exception(errorDataEmpty);
  }
}

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({Key? key, required this.kodeUnit}) : super(key: key);

  final String kodeUnit;

  @override
  Widget build(BuildContext context) {
    fetchDataTeknisi();
    return Scaffold(
      appBar: mxAppBar(
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
        title: 'Cari data',
      ),
      body: FutureBuilder<Perangkat?>(
        future: searchPerangkat(kodeUnit),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: blueBigText(
                      text: 'Data berhasil ditemukan',
                      size: 16,
                      color: Colors.green,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Card(
                            // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                            child: Column(
                              children: [
                                ExpansionTile(
                                  initiallyExpanded: true,
                                  title: blueBigText(text: 'Kode unit'),
                                  subtitle: Text(snapshot.data!.kodeUnit),
                                  children: [
                                    ListTile(
                                      title: blueBigText(text: 'Informasi', color: Colors.black87),
                                    ),
                                    const Divider(thickness: 1),
                                    perangkatTile(
                                      title: 'User',
                                      trail: snapshot.data!.namaUser,
                                    ),
                                    perangkatTile(
                                      title: 'Ruangan',
                                      trail: snapshot.data!.ruangan,
                                    ),
                                    perangkatTile(
                                      title: 'Merk unit',
                                      trail: snapshot.data!.namaUnit,
                                    ),
                                    perangkatTile(
                                      title: 'Type',
                                      trail: snapshot.data!.type,
                                    ),
                                    perangkatTile(
                                      title: 'Jenis',
                                      trail: snapshot.data!.perangkat,
                                    ),
                                    perangkatTile(
                                      title: 'Keterangan',
                                      trail: snapshot.data!.keterangan.trim() == '' ? '-' : snapshot.data!.keterangan,
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: SingleChildScrollView(
                child: mxErrorFuture(
                  snapshotErr: '${snapshot.error.toString()} "$kodeUnit"',
                  textColor: Colors.grey,
                  icon: Icons.search_off_outlined,
                  iconRefresh: Icons.add_link_outlined,
                  labelBtn: 'Masukkan ulang kode',
                  onPress: () async {
                    final String? kodeUnit = await openInsertCodeDialog(context: context);

                    if (kodeUnit != null && kodeUnit != '') {
                      var route = MaterialPageRoute(
                        builder: (BuildContext context) => SearchResultPage(kodeUnit: kodeUnit),
                      );
                      Navigator.of(context).pushReplacement(route);
                    }
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
          return Center(
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
                  kodeUnit,
                  style: const TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 80.0,
                ),
                SpinKitFoldingCube(
                  color: colorSecondary,
                ),
                const SizedBox(
                  height: 80.0,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

Widget perangkatTile({required title, required trail}) {
  return ListTile(
    // contentPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 0),
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    trailing: Text(
      trail,
    ),
  );
}
