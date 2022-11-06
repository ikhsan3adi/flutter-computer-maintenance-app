import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_maintenance_app/custom_widget/myBuilder.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/custom_widget/myFloatingActionButton.dart';
import 'package:project_maintenance_app/custom_widget/mycolor.dart';
import 'package:project_maintenance_app/data/data_model.dart';
import 'package:project_maintenance_app/data/helper.dart';
import 'package:project_maintenance_app/screens/add_data/add_perangkat/add_device.dart';
import 'package:project_maintenance_app/screens/appsettings/ipaddress.dart';
import 'package:project_maintenance_app/screens/show_data/device.dart';
import 'package:project_maintenance_app/screens/show_data/ruangan.dart';

class ChoosePerangkatPage extends StatefulWidget {
  const ChoosePerangkatPage({super.key, required this.ruangan});

  final Ruangan ruangan;

  @override
  State<ChoosePerangkatPage> createState() => _ChoosePerangkatPageState();
}

class _ChoosePerangkatPageState extends State<ChoosePerangkatPage> {
  late Future<Map<String, dynamic>?> myFuture;

  @override
  void initState() {
    super.initState();

    myFuture = countDevice(widget.ruangan.namaRuangan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mxAppBar(
        foregroundColor: colorSecondary,
        title: 'Ruangan ${widget.ruangan.namaRuangan}',
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
            setState(() => myFuture = countDevice(widget.ruangan.namaRuangan));
          });
        },
        child: FutureBuilder<Map<String, dynamic>?>(
          future: myFuture,
          builder: (context, snapshot) {
            return ListView(
              children: [
                mxCardListTile(
                  childLeading: const Icon(Icons.computer_outlined, color: Colors.white),
                  titleText: const Text('Komputer'),
                  subtitleText: snapshot.hasData ? 'Jumlah : ${snapshot.data!['komputer'].toString()}' : 'undefined',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DataDevice(ruangan: widget.ruangan, jenis: 'komputer')));
                  },
                ),
                mxCardListTile(
                  childLeading: const Icon(Icons.print, color: Colors.white),
                  titleText: const Text('Printer'),
                  subtitleText: snapshot.hasData ? 'Jumlah : ${snapshot.data!['printer'].toString()}' : 'undefined',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => DataDevice(ruangan: widget.ruangan, jenis: 'printer')));
                  },
                ),
              ],
            );
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

Future<Map<String, dynamic>?> countDevice(String ruangan) async {
  Response? response;
  try {
    response = await get(Uri(
      scheme: 'http',
      host: url,
      path: '$addressPath/getPerangkat/',
      queryParameters: {
        'ruangan': ruangan,
        'mode': 'count',
      },
    ));
  } catch (e) {
    throw Exception(errorConnection);
  }

  try {
    final deviceCount = json.decode(response.body);
    if (kDebugMode) {
      print(deviceCount);
    }
    return deviceCount;
  } catch (e) {
    throw 'undefined';
  }
}
