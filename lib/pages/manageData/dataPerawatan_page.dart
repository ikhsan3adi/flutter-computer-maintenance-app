// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_maintenance_app/customClasses/data.dart';
import 'package:project_maintenance_app/customClasses/myBuilder.dart';
import 'package:project_maintenance_app/customClasses/myScaffold.dart';
import 'package:project_maintenance_app/customClasses/myTextButton.dart';
import 'package:project_maintenance_app/pages/appsettings/ipaddress.dart';

// fake data
List<Perawatan> dummyPerawatan = [
  Perawatan(
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
  Perawatan(
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
  Perawatan(
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
  Perawatan(
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

Future<List<Perawatan>> downloadPerawatanJSON(String kodeUnit) async {
  Response? response;

  try {
    response = await get(Uri(
      scheme: 'http',
      host: iPAddress,
      path: '$apiPath/getPerawatan/',
      queryParameters: {'kode_unit': kodeUnit},
    ));
  } catch (e) {
    throw Exception(errorConnection);
  }

  try {
    List perawatan = json.decode(response.body);
    return perawatan.map((perawatan) => Perawatan.fromJson(perawatan)).toList();
  } catch (e) {
    throw Exception(errorDataEmpty);
  }
}

class DataPerawatan extends StatefulWidget {
  const DataPerawatan({Key? key, required this.device}) : super(key: key);

  final Perangkat device;

  @override
  State<DataPerawatan> createState() => _DataPerawatanState();
}

class _DataPerawatanState extends State<DataPerawatan> {
  late Future<List<Perawatan>> myFuture;

  @override
  void initState() {
    super.initState();

    myFuture = downloadPerawatanJSON(widget.device.kodeUnit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(
        title: 'Data perawatan',
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
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        elevation: 0.75,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                blueBigText(text: 'Kode : ${widget.device.kodeUnit}'),
                blueBigText(text: 'User : ${widget.device.namaUser}'),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 1000));
                  return Future(() {
                    setState(() {
                      myFuture = downloadPerawatanJSON(widget.device.kodeUnit);
                    });
                  });
                },
                child: FutureBuilder<List<Perawatan>>(
                  future: connectToDatabase ? myFuture : null,
                  initialData: connectToDatabase ? null : dummyPerawatan,
                  builder: (context, snapshot) {
                    String currentMonth = '00';
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          if (snapshot.data![index].kodeUnit == widget.device.kodeUnit) {
                            var xy = snapshot.data![index];
                            bool isCompleteAll = xy.pembersihan &&
                                xy.pengecekanChipset &&
                                xy.scanVirus &&
                                xy.pembersihanTemporary &&
                                xy.pengecekanSoftware &&
                                xy.installUpdateDriver;

                            String month = snapshot.data![index].tanggal.substring(3, 5);
                            String year = snapshot.data![index].tanggal.substring(6);

                            if (currentMonth != month) {
                              currentMonth = month;
                              // if (kDebugMode) {
                              //   print('current month : $currentMonth, month in snapshot : $month');
                              // }
                              return Column(
                                children: [
                                  Card(
                                    color: Colors.blueAccent,
                                    child: ListTile(
                                      title: Text('${bulan[int.parse(month)]} $year'),
                                      textColor: Colors.white,
                                    ),
                                  ),
                                  perawatanExpansionTile(isCompleteAll: isCompleteAll, snapshot: snapshot, index: index, xy: xy)
                                ],
                              );
                            } else {
                              return perawatanExpansionTile(isCompleteAll: isCompleteAll, snapshot: snapshot, index: index, xy: xy);
                            }
                          } else {
                            return const SizedBox();
                          }
                        }),
                      );
                    } else if (snapshot.hasError) {
                      String errMsg = snapshot.error.toString();

                      if (errMsg == 'Exception: $errorConnection') {
                        return mxErrorFuture(
                          snapshotErr: errMsg,
                          onPress: () {
                            setState(() {
                              myFuture = downloadPerawatanJSON(widget.device.kodeUnit);
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
                              myFuture = downloadPerawatanJSON(widget.device.kodeUnit);
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
      ),
    );
  }
}

Widget perawatanExpansionTile({required bool isCompleteAll, required snapshot, required index, required Perawatan xy}) {
  return Card(
    color: isCompleteAll ? const Color.fromARGB(255, 226, 255, 232) : Colors.white,
    child: ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.checklist_outlined,
          color: isCompleteAll ? Colors.blueAccent : Colors.grey,
        ),
      ),
      title: Text('Tanggal : ${snapshot.data![index].tanggal}'),
      subtitle: Text('Teknisi : ${snapshot.data![index].teknisi}'),
      children: [
        CheckboxListTile(
          value: xy.pembersihan,
          onChanged: (value) {},
          title: const Text('Pembersihan'),
        ),
        CheckboxListTile(
          value: xy.pengecekanChipset,
          onChanged: (value) {},
          title: const Text('Pengecekan chipset'),
        ),
        CheckboxListTile(
          value: xy.scanVirus,
          onChanged: (value) {},
          title: const Text('Scan virus'),
        ),
        CheckboxListTile(
          value: xy.pembersihanTemporary,
          onChanged: (value) {},
          title: const Text('Pembersihan temporary'),
        ),
        CheckboxListTile(
          value: xy.pengecekanSoftware,
          onChanged: (value) {},
          title: const Text('Pengecekan software'),
        ),
        CheckboxListTile(
          value: xy.installUpdateDriver,
          onChanged: (value) {},
          title: const Text('Install update software'),
        ),
        ListTile(
          title: Text('Keterangan : ${xy.keterangan}'),
        ),
      ],
    ),
  );
}
