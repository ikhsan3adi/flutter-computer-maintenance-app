import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_maintenance_app/custom_widget/myBuilder.dart';
import 'package:project_maintenance_app/custom_widget/myAppbar.dart';
import 'package:project_maintenance_app/models/data_model.dart';
import 'package:project_maintenance_app/utils/helper.dart';
import 'package:project_maintenance_app/utils/network.util.dart';
import 'package:project_maintenance_app/screens/add_data/add_perawatan/add_perawatan_komputer.dart';
import 'package:project_maintenance_app/screens/add_data/add_perawatan/add_perawatan_printer.dart';
import 'package:project_maintenance_app/pages/core_page.dart';

List<Teknisi> listTeknisi = [];

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
  Future<String>? postData() async {
    Map<String, dynamic> body;

    switch (widget.perangkat) {
      case 'printer':
        body = {
          'kode_unit': widget.newPerawatan.kodeUnit,
          'tanggal': widget.newPerawatan.tanggal,
          'pembersihan': boolToStr(widget.newPerawatan.pembersihan),
          'install_update_driver': boolToStr(widget.newPerawatan.installUpdateDriver),
          'keterangan': widget.newPerawatan.keterangan,
          'id_teknisi': widget.newPerawatan.teknisi,
        };
        break;
      case 'komputer':
      default:
        body = {
          'kode_unit': widget.newPerawatan.kodeUnit,
          'tanggal': widget.newPerawatan.tanggal,
          'pembersihan': boolToStr(widget.newPerawatan.pembersihan),
          'pengecekan_chipset': boolToStr(widget.newPerawatan.pengecekanChipset),
          'scan_virus': boolToStr(widget.newPerawatan.scanVirus),
          'pembersihan_temporary': boolToStr(widget.newPerawatan.pembersihanTemporary),
          'pengecekan_software': boolToStr(widget.newPerawatan.pengecekanSoftware),
          'install_update_driver': boolToStr(widget.newPerawatan.installUpdateDriver),
          'keterangan': widget.newPerawatan.keterangan,
          'id_teknisi': widget.newPerawatan.teknisi,
        };
    }

    final http.Response response = await queryData(
      httpVerbs: httpPOST,
      context: ctxPerawatan,
      action: actCreate,
      extraQueryParameters: {'perangkat': widget.perangkat},
      body: body,
    );

    if (kDebugMode) {
      print(response.body);
    }

    if (int.parse(response.body) == 1) {
      return int.parse(response.body).toString();
    } else {
      throw Exception('Gagal insert ke database');
    }
  }

  late Future<String>? myFuture;

  @override
  Widget build(BuildContext context) {
    myFuture = postData();
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
                        myFuture = postData();
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
      style: TextStyle(color: value ? Colors.blue : null),
    ),
    onChanged: onChanged,
    value: value,
  );
}
