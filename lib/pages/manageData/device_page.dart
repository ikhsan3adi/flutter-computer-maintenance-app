import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:project_maintenance_app/customClasses/data.dart';
import 'package:project_maintenance_app/customClasses/myScaffold.dart';
import 'package:project_maintenance_app/customClasses/myBuilder.dart';
import 'package:project_maintenance_app/pages/appsettings/ipaddress.dart';
import 'package:project_maintenance_app/pages/manageData/add_device_page.dart';
import 'package:project_maintenance_app/pages/manageData/dataPerawatan_page.dart';
import 'package:project_maintenance_app/pages/manageData/ruangan_page.dart';

// fake data
List<Perangkat> dummyPerangkat = [
  Perangkat(kodeUnit: 'FS-01', namaUser: 'Jaki', namaUnit: 'Lenovo', type: '0123', ruangan: 'Fasilitasi', keterangan: 'keterangan'),
  Perangkat(kodeUnit: 'FS-02', namaUser: 'Harlan', namaUnit: 'Lenovo', type: '0123', ruangan: 'Fasilitasi', keterangan: 'keterangan'),
  Perangkat(kodeUnit: 'TU-01', namaUser: 'Terkadang', namaUnit: 'Lenovo', type: '0123', ruangan: 'Tata Usaha', keterangan: 'keterangan'),
  Perangkat(kodeUnit: 'PS-01', namaUser: 'Gweh', namaUnit: 'Lenovo', type: '0123', ruangan: 'Persidangan', keterangan: 'keterangan'),
  Perangkat(kodeUnit: 'UM-01', namaUser: 'Asep', namaUnit: 'Lenovo', type: '0123', ruangan: 'Umum', keterangan: 'keterangan'),
  Perangkat(kodeUnit: 'HM-01', namaUser: 'Apabila', namaUnit: 'Lenovo', type: '0123', ruangan: 'Humas', keterangan: 'keterangan'),
  Perangkat(kodeUnit: 'KU-01', namaUser: 'Turi ip ip ip', namaUnit: 'Lenovo', type: '0123', ruangan: 'Keuangan', keterangan: 'keterangan'),
  Perangkat(kodeUnit: 'KU-01', namaUser: 'Zhong Xina', namaUnit: 'Asus', type: '0123', ruangan: 'Keuangan', keterangan: 'OOOOOMAAAGAAAA'),
];

Future<List<Perangkat>> downloadDeviceJSON(String ruangan) async {
  Response? response;
  try {
    response = await get(Uri(
      scheme: 'http',
      host: iPAddress,
      path: '$apiPath/getPerangkat/',
      queryParameters: {'ruangan': ruangan},
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
  const DataDevice({Key? key, required this.ruangan}) : super(key: key);

  final Ruangan ruangan;

  @override
  State<DataDevice> createState() => _DataDeviceState();
}

class _DataDeviceState extends State<DataDevice> {
  late Future<List<Perangkat>> myFuture;

  @override
  void initState() {
    super.initState();

    myFuture = downloadDeviceJSON(widget.ruangan.namaRuangan);
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("[Data_device] Current IP Address is : $iPAddress");
    }
    return Scaffold(
      appBar: mxAppBar(
        title: 'Daftar perangkat ruangan ${widget.ruangan.namaRuangan}',
        centerTitle: false,
        style: const TextStyle(color: Colors.blueAccent, fontSize: 16),
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
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() async {
            await Future.delayed(const Duration(milliseconds: 1000));
            setState(() {
              myFuture = downloadDeviceJSON(widget.ruangan.namaRuangan);
            });
          });
        },
        child: FutureBuilder<List<Perangkat>>(
          future: connectToDatabase ? myFuture : null,
          initialData: connectToDatabase ? null : dummyPerangkat,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return mxDataLoading();
              case ConnectionState.done:
              default:
                if (snapshot.hasData) {
                  return mxListViewBuilder(
                    snapshot: snapshot,
                    itemBuilder: (context, index) {
                      return snapshot.data![index].ruangan == widget.ruangan.namaRuangan
                          ? mxCardListTile(
                              hasTrailing: true,
                              trailing: PopupMenuButton(
                                itemBuilder: ((context) => [
                                      PopupMenuItem(
                                        onTap: (() async {
                                          String kodeUnit = snapshot.data![index].kodeUnit;

                                          bool b = await openDeleteDialog(context: context, kodeUnit: kodeUnit);

                                          if (!b) {
                                            return;
                                          } else {
                                            final uri = Uri(
                                              scheme: 'http',
                                              host: iPAddress,
                                              path: '$apiPath/deleteData/',
                                              queryParameters: {
                                                'tipe': 'Perangkat',
                                                'kode_unit': kodeUnit,
                                              },
                                            );

                                            var response = await post(uri);

                                            if (response.statusCode == 200) {
                                              if (int.parse(response.body.toString()) == 1) {
                                                setState(() {
                                                  myFuture = downloadDeviceJSON(widget.ruangan.namaRuangan);
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
                                            SizedBox(width: 5),
                                            Text('Hapus perangkat'),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                              snapshot: snapshot,
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
                            )
                          : const SizedBox();
                    },
                  );
                } else if (snapshot.hasError) {
                  String errMsg = snapshot.error.toString();
                  if (errMsg == 'Exception: $errorConnection') {
                    return mxErrorFuture(
                      snapshotErr: errMsg,
                      onPress: () {
                        setState(() {
                          myFuture = downloadDeviceJSON(widget.ruangan.namaRuangan);
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
                          myFuture = downloadDeviceJSON(widget.ruangan.namaRuangan);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var route = MaterialPageRoute(
            builder: ((context) {
              return AddDevice(ruangan: widget.ruangan.namaRuangan);
            }),
          );
          pushSecondHome(route: route);
        },
        tooltip: 'Tambah data perangkat',
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
        label: const Text('Tambah perangkat'),
        icon: const Icon(
          Icons.add,
          size: 30,
        ),
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
