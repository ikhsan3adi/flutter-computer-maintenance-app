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
import 'package:project_maintenance_app/custom_widget/myTextButton.dart';
import 'package:project_maintenance_app/data/helper.dart';
import 'package:project_maintenance_app/main.dart';
import 'package:project_maintenance_app/pages/core_page.dart';
import 'package:project_maintenance_app/screens/appsettings/ipaddress.dart';
import 'package:project_maintenance_app/screens/add_data/add_ruangan.dart';
import 'package:project_maintenance_app/screens/show_data/choose_device_type.dart';

// fake data
List<Ruangan> dummyRuangan = [
  Ruangan(id: "01", namaRuangan: "Umum", kode: "UM"),
  Ruangan(id: "02", namaRuangan: "Fasilitasi", kode: "FS"),
  Ruangan(id: "03", namaRuangan: "Keuangan", kode: "KU"),
  Ruangan(id: "04", namaRuangan: "Tata Usaha", kode: "TU"),
  Ruangan(id: "05", namaRuangan: "Humas", kode: "HM"),
  Ruangan(id: "06", namaRuangan: "Persidangan", kode: "PS"),
];

List<Ruangan> realRuangan = [];

Future<List<Ruangan>> downloadJSON() async {
  Response? response;
  try {
    final uri = Uri(
      scheme: 'http',
      host: url,
      path: '$addressPath/getRuangan/',
    );
    response = await get(uri);
  } catch (e) {
    throw Exception(errorConnection);
  }

  try {
    List ruangan = json.decode(response.body);
    realRuangan = ruangan.map((ruangan) => Ruangan.fromJson(ruangan)).toList();
    return realRuangan;
  } catch (e) {
    throw Exception(errorDataEmpty);
  }
}

class DataRuangan extends StatefulWidget {
  const DataRuangan({Key? key}) : super(key: key);

  @override
  State<DataRuangan> createState() => _DataRuanganState();
}

class _DataRuanganState extends State<DataRuangan> {
  Future<List<Ruangan>> myFuture = downloadJSON();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("[Data_ruangan] Current URL Address is : $url");
    }
    return Scaffold(
      appBar: mxAppBar(
        title: 'Ruangan',
        style: TextStyle(fontSize: 16, color: colorSecondary),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        // elevation: 0.75,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return Future(() {
            setState(() {
              myFuture = downloadJSON();
            });
          });
        },
        child: FutureBuilder<List<Ruangan>>(
          future: connectToDatabase ? myFuture : null,
          initialData: connectToDatabase ? null : dummyRuangan,
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
                      } else {
                        return ValueListenableBuilder(
                          valueListenable: currentTheme,
                          builder: (context, value, _) {
                            return mxCardListTile(
                              hasTrailing: true,
                              trailing: Builder(
                                builder: ((context) {
                                  return IconButton(
                                    onPressed: () async {
                                      String ruangan = snapshot.data![index].namaRuangan;
                                      String kodeRuangan = snapshot.data![index].kode;

                                      bool b = await openDeleteDialog(context: context, ruangan: ruangan);

                                      if (!b) {
                                        return;
                                      } else {
                                        final uri = Uri(
                                          scheme: 'http',
                                          host: url,
                                          path: '$addressPath/deleteData/',
                                          queryParameters: {
                                            'tipe': "Ruangan",
                                            'kode_ruangan': kodeRuangan,
                                          },
                                        );

                                        try {
                                          var response = await post(uri);
                                          if (kDebugMode) {
                                            print(response.body);
                                          }
                                          if (response.body.toString() == '1') {
                                            setState(() {
                                              myFuture = downloadJSON();
                                              Fluttertoast.showToast(msg: 'Hapus ruangan "$ruangan" berhasil');
                                            });
                                          } else {
                                            Fluttertoast.showToast(msg: 'Kesalahan script php');
                                          }
                                        } catch (e) {
                                          Fluttertoast.showToast(msg: 'Tidak dapat terhubung ke server, hapus ruangan "$ruangan" gagal : $e');
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.delete_forever),
                                  );
                                }),
                              ),
                              childLeading: const Icon(
                                Icons.home_outlined,
                                color: Colors.white,
                              ),
                              index: index,
                              titleText: Text(snapshot.data![index].namaRuangan),
                              subtitleText: 'Kode ruangan : ${snapshot.data![index].kode}',
                              onTap: () {
                                var route = MaterialPageRoute(
                                  builder: (BuildContext context) => ChoosePerangkatPage(ruangan: snapshot.data![index]),
                                );
                                Navigator.of(context).push(route);
                              },
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
                          myFuture = downloadJSON();
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
                          myFuture = downloadJSON();
                        });
                      },
                    );
                  }
                }
            }

            return mxDataLoading();
          },
        ),
      ),
      floatingActionButton: mxFloatingActionButton(
        label: 'Tambah ruangan',
        tooltip: 'Tambah data ruangan',
        onPressed: () {
          var route = MaterialPageRoute(builder: ((context) => const AddRuangan()));
          Navigator.of(coreScaffoldKey.currentContext!).popUntil((route) => route.isFirst);
          pushSecondHome(route: route);
        },
      ),
    );
  }

  Future<String?> openAddDataDialog<String>() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah data'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                mxTextButtonNoIcon(
                    buttonPadding: 15,
                    label: 'Tambah ruangan',
                    onPress: () {
                      Navigator.of(context).pop('ruangan');
                    }),
                const SizedBox(height: 10),
                mxTextButtonNoIcon(
                    buttonPadding: 15,
                    label: 'Tambah perangkat',
                    onPress: (() {
                      Navigator.of(context).pop('perangkat');
                    })),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Kembali'),
            )
          ],
        );
      },
    );
  }
}

void pushSecondHome({required MaterialPageRoute route}) {
  Navigator.of(coreScaffoldKey.currentContext!).push(route);
}

Future<bool?> openDeleteDialog<bool>({required BuildContext context, required String ruangan}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Apakah yakin ingin menghapus ruangan $ruangan?'),
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
