import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:project_maintenance_app/custom_widget/myFloatingActionButton.dart';
import 'package:project_maintenance_app/custom_widget/mycolor.dart';
import 'package:project_maintenance_app/data/data_model.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myBuilder.dart';
import 'package:project_maintenance_app/data/helper.dart';
import 'package:project_maintenance_app/main.dart';
import 'package:project_maintenance_app/screens/add_data/add_perawatan/add_perawatan.dart';
import 'package:project_maintenance_app/screens/appsettings/ipaddress.dart';
import 'package:project_maintenance_app/screens/add_data/add_perangkat/add_device.dart';
import 'package:project_maintenance_app/pages/core_page.dart';
import 'package:project_maintenance_app/screens/show_data/dataPerawatan.dart';
import 'package:project_maintenance_app/screens/show_data/ruangan.dart';

// fake data
List<Perangkat> dummyPerangkat = [
  Perangkat(
      kodeUnit: 'FS-01', perangkat: 'komputer', namaUser: 'Jaki', namaUnit: 'Lenovo', type: '0123', ruangan: 'Fasilitasi', keterangan: 'keterangan'),
  Perangkat(
      kodeUnit: 'FS-02',
      perangkat: 'komputer',
      namaUser: 'Harlan',
      namaUnit: 'Lenovo',
      type: '0123',
      ruangan: 'Fasilitasi',
      keterangan: 'keterangan'),
  Perangkat(
      kodeUnit: 'TU-01',
      perangkat: 'komputer',
      namaUser: 'Terkadang',
      namaUnit: 'Lenovo',
      type: '0123',
      ruangan: 'Tata Usaha',
      keterangan: 'keterangan'),
  Perangkat(
      kodeUnit: 'PS-01', perangkat: 'komputer', namaUser: 'Gweh', namaUnit: 'Lenovo', type: '0123', ruangan: 'Persidangan', keterangan: 'keterangan'),
  Perangkat(kodeUnit: 'UM-01', perangkat: 'komputer', namaUser: 'Asep', namaUnit: 'Lenovo', type: '0123', ruangan: 'Umum', keterangan: 'keterangan'),
  Perangkat(
      kodeUnit: 'HM-01', perangkat: 'komputer', namaUser: 'Apabila', namaUnit: 'Lenovo', type: '0123', ruangan: 'Humas', keterangan: 'keterangan'),
  Perangkat(
      kodeUnit: 'KU-01',
      perangkat: 'komputer',
      namaUser: 'Turi ip ip ip',
      namaUnit: 'Lenovo',
      type: '0123',
      ruangan: 'Keuangan',
      keterangan: 'keterangan'),
  Perangkat(
      kodeUnit: 'KU-01',
      perangkat: 'komputer',
      namaUser: 'Zhong Xina',
      namaUnit: 'Asus',
      type: '0123',
      ruangan: 'Keuangan',
      keterangan: 'OOOOOMAAAGAAAA'),
];

Future<List<Perangkat>> downloadDeviceJSON(String ruangan, String jenis) async {
  Response? response;
  try {
    response = await get(Uri(
      scheme: 'http',
      host: url,
      path: '$addressPath/getPerangkat/',
      queryParameters: {
        'ruangan': ruangan,
        'perangkat': jenis,
        'mode': 'select',
      },
    ));
  } catch (e) {
    throw Exception(errorConnection);
  }

  try {
    List device = json.decode(response.body);
    return device.map((device) => Perangkat.fromJson(device)).toList();
  } catch (e) {
    throw Exception(errorDataEmpty);
  }
}

class DataDevice extends StatefulWidget {
  const DataDevice({Key? key, required this.ruangan, required this.jenis}) : super(key: key);

  final Ruangan ruangan;
  final String jenis;

  @override
  State<DataDevice> createState() => _DataDeviceState();
}

class _DataDeviceState extends State<DataDevice> {
  late Future<List<Perangkat>> myFuture;

  @override
  void initState() {
    super.initState();

    myFuture = downloadDeviceJSON(widget.ruangan.namaRuangan, widget.jenis);
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("[Data_device] Current URL Address is : $url");
    }
    return Scaffold(
      appBar: mxAppBar(
        foregroundColor: colorSecondary,
        title: 'Daftar ${widget.jenis} ruangan ${widget.ruangan.namaRuangan}',
        centerTitle: false,
        style: TextStyle(fontSize: 16, color: colorSecondary),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.maybePop(context),
              tooltip: 'Kembali',
            );
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() async {
            setState(() {
              myFuture = downloadDeviceJSON(widget.ruangan.namaRuangan, widget.jenis);
            });
          });
        },
        child: FutureBuilder<List<Perangkat>>(
          future: myFuture,
          // initialData: connectToDatabase ? null : dummyPerangkat,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return mxDataLoading();
              case ConnectionState.done:
              default:
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= snapshot.data!.length) {
                        return const SizedBox(height: 75);
                      } else if (snapshot.data![index].ruangan != widget.ruangan.namaRuangan) {
                        return const SizedBox();
                      } else {
                        return ValueListenableBuilder(
                          valueListenable: currentTheme,
                          builder: (context, value, _) {
                            return mxCardListTile(
                              hasTrailing: true,
                              trailing: PopupMenuButton(
                                itemBuilder: ((context) => [
                                      PopupMenuItem(
                                        onTap: (() {
                                          var route = MaterialPageRoute(builder: (context) {
                                            return AddPerawatan(perangkat: snapshot.data![index]);
                                          });
                                          Navigator.of(coreScaffoldKey.currentContext!).push(route);
                                        }),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.add_link),
                                            SizedBox(width: 10),
                                            Text('Tambah data perawatan'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        onTap: (() async {
                                          String kodeUnit = snapshot.data![index].kodeUnit;

                                          bool b = await openDeleteDialog(context: context, kodeUnit: kodeUnit);

                                          if (!b) {
                                            return;
                                          } else {
                                            final uri = Uri(
                                              scheme: 'http',
                                              host: url,
                                              path: '$addressPath/deleteData/',
                                              queryParameters: {
                                                'tipe': 'Perangkat',
                                                'kode_unit': kodeUnit,
                                              },
                                            );

                                            var response = await post(uri);

                                            if (response.statusCode == 200) {
                                              if (int.parse(response.body.toString()) == 1) {
                                                setState(() {
                                                  myFuture = downloadDeviceJSON(widget.ruangan.namaRuangan, widget.jenis);
                                                  Fluttertoast.showToast(msg: 'Hapus data $kodeUnit berhasil');
                                                  // print(response.body);
                                                });
                                              } else {
                                                Fluttertoast.showToast(msg: 'Kesalahan script php');
                                              }
                                            } else {
                                              Fluttertoast.showToast(msg: 'Tidak dapat terhubung ke server');
                                            }
                                          }
                                        }),
                                        child: Row(
                                          children: const [
                                            Icon(Icons.delete),
                                            SizedBox(width: 10),
                                            Text('Hapus perangkat'),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                              index: index,
                              titleText: Text(
                                snapshot.data![index].namaUser,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitleText:
                                  'Kode unit : ${snapshot.data![index].kodeUnit}\nMerk unit : ${snapshot.data![index].namaUnit} ${snapshot.data![index].type}',
                              onTap: () {
                                var route = MaterialPageRoute(
                                  builder: (BuildContext context) => DataPerawatan(device: snapshot.data![index]),
                                );
                                Navigator.of(context).push(route);
                              },
                              leadingBackgroundColor: Colors.transparent,
                              childLeading: const Icon(Icons.computer),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            );
                          },
                        );
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  String errMsg = snapshot.error.toString();
                  if (errMsg == 'Exception: $errorConnection') {
                    return mxErrorFuture(
                      snapshotErr: errMsg,
                      onPress: () {
                        setState(() {
                          myFuture = downloadDeviceJSON(widget.ruangan.namaRuangan, widget.jenis);
                        });
                      },
                    );
                  } else if (errMsg == 'Exception: $errorDataEmpty') {
                    return mxErrorFuture(
                      snapshotErr: errMsg,
                      icon: Icons.search_off_outlined,
                      textColor: Colors.grey,
                      onPress: () {
                        setState(() {
                          myFuture = downloadDeviceJSON(widget.ruangan.namaRuangan, widget.jenis);
                        });
                      },
                    );
                  }
                }
            }

            //return  a circular progress indicator.
            return mxDataLoading();
          },
        ),
      ),
      floatingActionButton: mxFloatingActionButton(
        label: 'Tambah perangkat',
        tooltip: 'Tambah data perangkat',
        onPressed: () {
          var route = MaterialPageRoute(builder: ((context) => AddDevice(ruangan: widget.ruangan.namaRuangan)));
          pushSecondHome(route: route);
        },
      ),
    );
  }
}

Future<bool?> openDeleteDialog<bool>({required BuildContext context, required String kodeUnit}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Apakah yakin ingin menghapus $kodeUnit?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Ya'),
          )
        ],
      );
    },
  );
}
