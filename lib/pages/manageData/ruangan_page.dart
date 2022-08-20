// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:project_maintenance_app/customClasses/data.dart';
import 'package:project_maintenance_app/customClasses/myScaffold.dart';
import 'package:project_maintenance_app/customClasses/myBuilder.dart';
import 'package:project_maintenance_app/customClasses/myTextButton.dart';
import 'package:project_maintenance_app/main.dart';
import 'package:project_maintenance_app/pages/appsettings/ipaddress.dart';
import 'package:project_maintenance_app/pages/manageData/add_ruangan_page.dart';
import 'package:project_maintenance_app/pages/manageData/device_page.dart';

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
      host: iPAddress,
      path: '$apiPath/getRuangan/',
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

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

class SecondHome extends StatefulWidget {
  const SecondHome({Key? key}) : super(key: key);

  @override
  State<SecondHome> createState() => _SecondHomeState();
}

class _SecondHomeState extends State<SecondHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: mxAppBar(
        title: 'Data Perangkat',
        leading: Builder(
          builder: ((context) {
            return IconButton(
              onPressed: () {
                openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          }),
        ),
      ),
      body: Navigator(
        initialRoute: '/',
        onGenerateRoute: (settings) {
          WidgetBuilder builder;

          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => const DataRuangan();
              break;

            default:
              throw Exception('Invalid route ${settings.name}');
          }

          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }
}

// route
class DataRuangan extends StatefulWidget {
  const DataRuangan({Key? key}) : super(key: key);

  @override
  State<DataRuangan> createState() => _DataRuanganState();
}

class _DataRuanganState extends State<DataRuangan> {
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

  Future<List<Ruangan>> myFuture = downloadJSON();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("[Data_ruangan] Current IP Address is : $iPAddress");
    }
    return Scaffold(
      appBar: mxAppBar(
          title: 'Ruangan',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blueAccent,
          ),
          centerTitle: false),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1000));
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
                  return mxListViewBuilder(
                    snapshot: snapshot,
                    itemBuilder: (context, index) {
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
                                    host: iPAddress,
                                    path: '$apiPath/deleteData/',
                                    queryParameters: {
                                      'tipe': "Ruangan",
                                      'kode_ruangan': kodeRuangan,
                                    },
                                  );

                                  var response = await post(uri);

                                  if (response.statusCode == 200) {
                                    if (int.parse(response.body.toString()) == 1) {
                                      setState(() {
                                        myFuture = downloadJSON();
                                        Fluttertoast.showToast(msg: 'Hapus ruangan "$ruangan" berhasil');
                                      });
                                    } else {
                                      Fluttertoast.showToast(msg: 'Kesalahan script php');
                                    }
                                    // print(response.body);
                                  } else {
                                    Fluttertoast.showToast(msg: 'Tidak dapat terhubung ke server, hapus ruangan "$ruangan" gagal');
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
                        snapshot: snapshot,
                        index: index,
                        titleText: Text(snapshot.data![index].namaRuangan),
                        subtitleText: 'Kode ruangan : ${snapshot.data![index].kode}',
                        onTap: () {
                          var route = MaterialPageRoute(
                            builder: (BuildContext context) => DataDevice(ruangan: snapshot.data![index]),
                          );
                          Navigator.of(context).push(route);
                        },
                      );
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          var route = MaterialPageRoute(
            builder: ((context) {
              return const AddRuangan();
            }),
          );
          Navigator.of(_scaffoldKey.currentContext!).popUntil((route) => route.isFirst);
          pushSecondHome(route: route);
        },
        tooltip: 'Tambah data ruangan',
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
        label: const Text('Tambah ruangan'),
        icon: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}

void pushSecondHome({required MaterialPageRoute route}) {
  Navigator.of(_scaffoldKey.currentContext!).push(route);
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
