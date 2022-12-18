import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:project_maintenance_app/custom_widget/myFloatingActionButton.dart';
import 'package:project_maintenance_app/custom_widget/mycolor.dart';
import 'package:project_maintenance_app/models/data_model.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myBuilder.dart';
import 'package:project_maintenance_app/custom_widget/myTextButton.dart';
import 'package:project_maintenance_app/utils/helper.dart';
import 'package:project_maintenance_app/utils/network.util.dart';
import 'package:project_maintenance_app/main.dart';
import 'package:project_maintenance_app/pages/core_page.dart';
import 'package:project_maintenance_app/screens/appsettings/ipaddress.dart';
import 'package:project_maintenance_app/screens/add_data/add_ruangan.dart';
import 'package:project_maintenance_app/screens/show_data/choose_device_type.dart';

List<Ruangan> realRuangan = [];

class DataRuangan extends StatefulWidget {
  const DataRuangan({Key? key}) : super(key: key);

  @override
  State<DataRuangan> createState() => _DataRuanganState();
}

class _DataRuanganState extends State<DataRuangan> {
  // fetch data from API
  Future<List<Ruangan>> fetchDataRuangan() async {
    http.Response? response = await queryData(httpVerbs: httpGET, context: ctxRuangan, action: actSelect);

    try {
      List ruangan = json.decode(response.body);
      realRuangan = ruangan.map((ruangan) => Ruangan.fromJson(ruangan)).toList();
      return realRuangan;
    } catch (e) {
      throw Exception(errorDataEmpty);
    }
  }

  late Future<List<Ruangan>> myFuture = fetchDataRuangan();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print("[Data_ruangan] Current URL Address is : $url");

    return Scaffold(
      appBar: mxAppBar(
        title: 'Ruangan',
        style: TextStyle(fontSize: 16, color: colorSecondary),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        // elevation: 0.75,
      ),
      body: RefreshIndicator(
        onRefresh: () async => Future(() {
          setState(() {
            myFuture = fetchDataRuangan();
          });
        }),
        child: FutureBuilder<List<Ruangan>>(
          future: myFuture,
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
                                    onPressed: () async => await deleteRuangan(snapshot.data![index].namaRuangan, snapshot.data![index].kode),
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
                          myFuture = fetchDataRuangan();
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
                          myFuture = fetchDataRuangan();
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
          pushRootRoute(route: route);
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

  Future<void> deleteRuangan(String ruangan, String kodeRuangan) async {
    bool b = await openDeleteDialog(context: context, ruangan: ruangan);

    if (!b) return;

    final http.Response response = await queryData(
      httpVerbs: httpPOST,
      context: ctxRuangan,
      action: actDelete,
      body: {'kode_ruangan': kodeRuangan},
    );

    if (kDebugMode) print(response.body);

    try {
      if (int.parse(response.body) != 1) {
        Fluttertoast.showToast(msg: 'Kesalahan script php');
        return;
      }
      setState(() {
        myFuture = fetchDataRuangan();
        Fluttertoast.showToast(msg: 'Hapus ruangan "$ruangan" berhasil');
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Hapus ruangan "$ruangan" gagal : $e');
    }
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
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Ya'),
            )
          ],
        );
      },
    );
  }
}
