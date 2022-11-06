import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_maintenance_app/custom_widget/myBuilder.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/data/data_model.dart';
import 'package:project_maintenance_app/data/helper.dart';
import 'package:project_maintenance_app/screens/add_data/add_perawatan/add_perawatan_komputer.dart';
import 'package:project_maintenance_app/screens/add_data/add_perawatan/add_perawatan_printer.dart';
import 'package:project_maintenance_app/screens/appsettings/ipaddress.dart';
import 'package:project_maintenance_app/pages/core_page.dart';

class AddPerawatan extends StatelessWidget {
  const AddPerawatan({super.key, required this.perangkat});

  final Perangkat perangkat;

  @override
  Widget build(BuildContext context) {
    switch (perangkat.perangkat) {
      case 'komputer':
        return AddPerawatanKomputer(perangkat: perangkat);
      case 'printer':
        return AddPerawatanPrinter(perangkat: perangkat);
      default:
        return const Scaffold();
    }
  }
}

class AddPerawatanResult extends StatefulWidget {
  const AddPerawatanResult({Key? key, required this.newPerawatan, required this.perangkat}) : super(key: key);

  final String perangkat;
  final dynamic newPerawatan;

  @override
  State<AddPerawatanResult> createState() => _AddPerawatanResultState();
}

class _AddPerawatanResultState extends State<AddPerawatanResult> {
  Future<String>? postDataKomputer() async {
    final uri = Uri(
      scheme: 'http',
      host: url,
      path: '$addressPath/createNewPerawatan/',
      queryParameters: {
        'perangkat': 'komputer',
        'kode_unit': widget.newPerawatan.kodeUnit,
        'tanggal': widget.newPerawatan.tanggal,
        'pembersihan': boolToStr(widget.newPerawatan.pembersihan),
        'pengecekan_chipset': boolToStr(widget.newPerawatan.pengecekanChipset),
        'scan_virus': boolToStr(widget.newPerawatan.scanVirus),
        'pembersihan_temporary': boolToStr(widget.newPerawatan.pembersihanTemporary),
        'pengecekan_software': boolToStr(widget.newPerawatan.pengecekanSoftware),
        'install_update_driver': boolToStr(widget.newPerawatan.installUpdateDriver),
        'keterangan': widget.newPerawatan.keterangan,
        'nama_teknisi': widget.newPerawatan.teknisi,
      },
    );

    final Response response;
    try {
      response = await post(uri);
    } catch (e) {
      throw Exception(errorConnection);
    }

    if (int.parse(response.body) == 1) {
      return int.parse(response.body).toString();
    } else {
      throw Exception('Gagal insert ke database');
    }
  }

  Future<String>? postDataPrinter() async {
    final uri = Uri(
      scheme: 'http',
      host: url,
      path: '$addressPath/createNewPerawatan/',
      queryParameters: {
        'perangkat': 'printer',
        'kode_unit': widget.newPerawatan.kodeUnit,
        'tanggal': widget.newPerawatan.tanggal,
        'pembersihan': boolToStr(widget.newPerawatan.pembersihan),
        'install_update_driver': boolToStr(widget.newPerawatan.installUpdateDriver),
        'keterangan': widget.newPerawatan.keterangan,
        'nama_teknisi': widget.newPerawatan.teknisi,
      },
    );

    final Response response;
    try {
      response = await post(uri);
    } catch (e) {
      throw Exception(errorConnection);
    }

    if (int.parse(response.body) == 1) {
      return int.parse(response.body).toString();
    } else {
      throw Exception('Gagal insert ke database');
    }
  }

  Future<String>? switchPerangkatType() {
    switch (widget.perangkat) {
      case 'komputer':
        return postDataKomputer();
      case 'printer':
        return postDataPrinter();
      default:
        return postDataKomputer();
    }
  }

  late Future<String>? myFuture;

  @override
  Widget build(BuildContext context) {
    myFuture = switchPerangkatType();
    return Scaffold(
      appBar: mxAppBar(
        title: 'Tambah perawatan baru',
        leading: Builder(
          builder: ((context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.maybePop(context);
              },
              tooltip: 'Kembali',
            );
          }),
        ),
      ),
      body: FutureBuilder<String>(
        future: myFuture,
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return mxDataLoading(text: 'Sending data...');
            case ConnectionState.done:
            default:
              if (snapshot.hasData) {
                return mxErrorFuture(
                  icon: Icons.check,
                  iconColor: Colors.green,
                  textColor: Colors.blue,
                  snapshotErr: 'Insert data berhasil',
                  labelBtn: 'Lihat data',
                  iconRefresh: Icons.list,
                  onPress: () {
                    pageIndex.value = 1;

                    Navigator.of(context).popUntil(
                      (route) {
                        return route.isFirst;
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                if (snapshot.error.toString() == errorConnection) {
                  return mxErrorFuture(
                    snapshotErr: snapshot.error.toString(),
                    labelBtn: 'Coba lagi',
                    onPress: () {
                      setState(() {
                        myFuture = switchPerangkatType();
                      });
                    },
                  );
                } else {
                  return mxErrorFuture(
                    icon: Icons.do_not_disturb_alt_outlined,
                    snapshotErr: '${snapshot.error}',
                    labelBtn: 'Lihat data',
                    iconRefresh: Icons.home_outlined,
                    onPress: () {
                      pageIndex.value = 1;
                      Navigator.of(context).popUntil((route) {
                        return route.isFirst;
                      });
                    },
                  );
                }
              }
          }
          return mxDataLoading(text: 'Sending data...');
        }),
      ),
    );
  }
}

Widget mXcheckBoxListTile({required title, required Function(bool?)? onChanged, required bool value, focusNode}) {
  return CheckboxListTile(
    focusNode: focusNode,
    title: Text(
      title,
      style: TextStyle(color: value ? Colors.blue : Colors.grey[800]),
    ),
    onChanged: onChanged,
    value: value,
  );
}
