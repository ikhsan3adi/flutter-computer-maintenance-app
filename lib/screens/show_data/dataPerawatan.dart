// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_maintenance_app/custom_widget/mycolor.dart';
import 'package:project_maintenance_app/data/data_model.dart';
import 'package:project_maintenance_app/custom_widget/myBuilder.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myTextButton.dart';
import 'package:project_maintenance_app/data/helper.dart';
import 'package:project_maintenance_app/main.dart';
import 'package:project_maintenance_app/screens/appsettings/ipaddress.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

// fake data
List<PerawatanKomputer> dummyPerawatan = [
  PerawatanKomputer(
      id: 0,
      kodeUnit: 'UM-01',
      tanggal: '01-08-2022',
      pembersihan: false,
      pengecekanChipset: true,
      scanVirus: true,
      pembersihanTemporary: true,
      pengecekanSoftware: true,
      installUpdateDriver: true,
      keterangan: 'sering bluescreen',
      teknisi: 'Ikhsan'),
  PerawatanKomputer(
      id: 0,
      kodeUnit: 'UM-01',
      tanggal: '01-09-2022',
      pembersihan: true,
      pengecekanChipset: true,
      scanVirus: true,
      pembersihanTemporary: true,
      pengecekanSoftware: true,
      installUpdateDriver: true,
      keterangan: 'aman',
      teknisi: 'Rizky'),
  PerawatanKomputer(
      id: 0,
      kodeUnit: 'UM-01',
      tanggal: '01-10-2022',
      pembersihan: false,
      pengecekanChipset: true,
      scanVirus: true,
      pembersihanTemporary: true,
      pengecekanSoftware: true,
      installUpdateDriver: true,
      keterangan: 'sip',
      teknisi: 'Ilham'),
  PerawatanKomputer(
      id: 0,
      kodeUnit: 'UM-01',
      tanggal: '04-10-2022',
      pembersihan: false,
      pengecekanChipset: true,
      scanVirus: true,
      pembersihanTemporary: true,
      pengecekanSoftware: true,
      installUpdateDriver: true,
      keterangan: 'sip',
      teknisi: 'Ilham'),
];

class DataPerawatan extends StatefulWidget {
  const DataPerawatan({Key? key, required this.device}) : super(key: key);

  final Perangkat device;

  @override
  State<DataPerawatan> createState() => _DataPerawatanState();
}

class _DataPerawatanState extends State<DataPerawatan> {
  Future<List<Perawatan>> downloadPerawatanJSON(String kodeUnit, String perangkat) async {
    Response? response;

    try {
      response = await get(Uri(
        scheme: 'http',
        host: url,
        path: '$addressPath/getPerawatan/',
        queryParameters: {'kode_unit': kodeUnit, 'perangkat': perangkat},
      ));
    } catch (e) {
      throw Exception(errorConnection);
    }

    try {
      List perawatan = json.decode(response.body);
      switch (perangkat) {
        case 'komputer':
          return perawatan.map((perawatan) => PerawatanKomputer.fromJson(perawatan)).toList();
        case 'printer':
          return perawatan.map((perawatan) => PerawatanPrinter.fromJson(perawatan)).toList();
        default:
          return perawatan.map((perawatan) => PerawatanKomputer.fromJson(perawatan)).toList();
      }
    } catch (e) {
      throw Exception(errorDataEmpty);
    }
  }

  late Future<List<Perawatan>> myFuture;

  @override
  void initState() {
    super.initState();

    myFuture = downloadPerawatanJSON(
      widget.device.kodeUnit,
      widget.device.perangkat,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(
        foregroundColor: colorSecondary,
        title: 'Data perawatan',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                blueBigText(text: 'Kode : ${widget.device.kodeUnit}', size: 16),
                blueBigText(text: 'User : ${widget.device.namaUser}', size: 16),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Flexible(
            child: RefreshIndicator(
              onRefresh: () async {
                return Future(() {
                  setState(() {
                    myFuture = downloadPerawatanJSON(widget.device.kodeUnit, widget.device.perangkat);
                  });
                });
              },
              child: FutureBuilder<List<Perawatan>>(
                future: myFuture,
                // initialData: connectToDatabase ? null : dummyPerawatan,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ValueListenableBuilder(
                      valueListenable: currentTheme,
                      builder: (context, value, _) {
                        return StickyGroupedListView<Perawatan, String>(
                          elements: snapshot.data!,
                          itemBuilder: (context, element) {
                            if (element.kodeUnit == widget.device.kodeUnit) {
                              switch (widget.device.perangkat) {
                                case 'komputer':
                                  return komputerListTileBuilder(element as PerawatanKomputer);
                                case 'printer':
                                  return printerListTileBuilder(element as PerawatanPrinter);
                                default:
                                  return komputerListTileBuilder(element as PerawatanKomputer);
                              }
                            } else {
                              return const SizedBox();
                            }
                          },
                          floatingHeader: true,
                          shrinkWrap: true,
                          groupBy: (element) {
                            return element.tanggal.substring(3, 5);
                          },
                          groupComparator: (value1, value2) {
                            return value2.compareTo(value1);
                          },
                          groupSeparatorBuilder: (element) {
                            String month = element.tanggal.substring(3, 5);
                            String year = element.tanggal.substring(6);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    color: colorSecondary,
                                  ),
                                  child: Text(
                                    '${bulan[int.parse(month)]} $year',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ],
                            );
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
                            myFuture = downloadPerawatanJSON(widget.device.kodeUnit, widget.device.perangkat);
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
                            myFuture = downloadPerawatanJSON(widget.device.kodeUnit, widget.device.perangkat);
                          });
                        },
                      );
                    }
                  }
                  //return  a circular progress indicator.
                  return mxDataLoading();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget komputerListTileBuilder(PerawatanKomputer snapshot) {
    bool isCompleteAll;

    PerawatanKomputer xy = snapshot;

    isCompleteAll =
        xy.pembersihan && xy.pengecekanChipset && xy.scanVirus && xy.pembersihanTemporary && xy.pengecekanSoftware && xy.installUpdateDriver;

    Color? cardColor;

    if (currentTheme.value == ThemeMode.light) {
      cardColor ??= isCompleteAll ? const Color.fromARGB(255, 226, 255, 232) : Colors.white;
    } else {
      cardColor ??= isCompleteAll ? const Color.fromARGB(255, 54, 78, 65) : null;
    }

    return Card(
      color: cardColor,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            Icons.checklist_outlined,
            color: isCompleteAll ? Colors.blueAccent : Colors.grey,
          ),
        ),
        title: Text('Tanggal : ${snapshot.tanggal}'),
        subtitle: Text('Teknisi : ${snapshot.teknisi}'),
        children: [
          CheckboxListTile(
            value: snapshot.pembersihan,
            onChanged: (value) {},
            title: const Text('Pembersihan'),
          ),
          CheckboxListTile(
            value: snapshot.pengecekanChipset,
            onChanged: (value) {},
            title: const Text('Pengecekan chipset'),
          ),
          CheckboxListTile(
            value: snapshot.scanVirus,
            onChanged: (value) {},
            title: const Text('Scan virus'),
          ),
          CheckboxListTile(
            value: snapshot.pembersihanTemporary,
            onChanged: (value) {},
            title: const Text('Pembersihan temporary files'),
          ),
          CheckboxListTile(
            value: snapshot.pengecekanSoftware,
            onChanged: (value) {},
            title: const Text('Pengecekan software'),
          ),
          CheckboxListTile(
            value: snapshot.installUpdateDriver,
            onChanged: (value) {},
            title: const Text('Install update software'),
          ),
          ListTile(
            title: Text('Keterangan : ${snapshot.keterangan}'),
          ),
        ],
      ),
    );
  }

  Widget printerListTileBuilder(PerawatanPrinter snapshot) {
    bool isCompleteAll;

    isCompleteAll = snapshot.pembersihan && snapshot.installUpdateDriver;

    Color? cardColor;

    if (currentTheme.value == ThemeMode.light) {
      cardColor ??= isCompleteAll ? const Color.fromARGB(255, 226, 255, 232) : Colors.white;
    } else {
      cardColor ??= isCompleteAll ? const Color.fromARGB(255, 54, 78, 65) : null;
    }

    return Card(
      color: cardColor,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            Icons.checklist_outlined,
            color: isCompleteAll ? Colors.blueAccent : Colors.grey,
          ),
        ),
        title: Text('Tanggal : ${snapshot.tanggal}'),
        subtitle: Text('Teknisi : ${snapshot.teknisi}'),
        children: [
          CheckboxListTile(
            value: snapshot.pembersihan,
            onChanged: (value) {},
            title: const Text('Pembersihan'),
          ),
          CheckboxListTile(
            value: snapshot.installUpdateDriver,
            onChanged: (value) {},
            title: const Text('Install update software'),
          ),
          ListTile(
            title: Text('Keterangan : ${snapshot.keterangan}'),
          ),
        ],
      ),
    );
  }
}
